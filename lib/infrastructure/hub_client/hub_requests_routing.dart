import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cybear_jinni/domain/device/i_device_repository.dart';
import 'package:cybear_jinni/domain/generic_devices/abstract_device/device_entity_abstract.dart';
import 'package:cybear_jinni/domain/hub/i_hub_connection_repository.dart';
import 'package:cybear_jinni/domain/room/i_room_repository.dart';
import 'package:cybear_jinni/domain/room/room_entity.dart';
import 'package:cybear_jinni/domain/scene/i_scene_cbj_repository.dart';
import 'package:cybear_jinni/infrastructure/core/gen/cbj_hub_server/protoc_as_dart/cbj_hub_server.pbgrpc.dart';
import 'package:cybear_jinni/infrastructure/generic_devices/generic_blinds_device/generic_blinds_device_dtos.dart';
import 'package:cybear_jinni/infrastructure/generic_devices/generic_boiler_device/generic_boiler_device_dtos.dart';
import 'package:cybear_jinni/infrastructure/generic_devices/generic_dimmable_light_device/generic_dimmable_light_device_dtos.dart';
import 'package:cybear_jinni/infrastructure/generic_devices/generic_empty_device/generic_empty_device_dtos.dart';
import 'package:cybear_jinni/infrastructure/generic_devices/generic_light_device/generic_light_device_dtos.dart';
import 'package:cybear_jinni/infrastructure/generic_devices/generic_ping_device/generic_ping_device_dtos.dart';
import 'package:cybear_jinni/infrastructure/generic_devices/generic_printer_device/generic_printer_device_dtos.dart';
import 'package:cybear_jinni/infrastructure/generic_devices/generic_rgbw_light_device/generic_rgbw_light_device_dtos.dart';
import 'package:cybear_jinni/infrastructure/generic_devices/generic_smart_computer_device/generic_smart_computer_device_dtos.dart';
import 'package:cybear_jinni/infrastructure/generic_devices/generic_smart_plug_device/generic_smart_plug_device_dtos.dart';
import 'package:cybear_jinni/infrastructure/generic_devices/generic_smart_tv_device/generic_smart_tv_device_dtos.dart';
import 'package:cybear_jinni/infrastructure/generic_devices/generic_switch_device/generic_switch_device_dtos.dart';
import 'package:cybear_jinni/infrastructure/hub_client/hub_client.dart';
import 'package:cybear_jinni/infrastructure/objects/enums_cbj.dart';
import 'package:cybear_jinni/infrastructure/room/room_entity_dtos.dart';
import 'package:cybear_jinni/infrastructure/scenes/scene_cbj_dtos.dart';
import 'package:cybear_jinni/injection.dart';
import 'package:cybear_jinni/utils.dart';
import 'package:grpc/grpc.dart';

class HubRequestRouting {
  static StreamSubscription<RequestsAndStatusFromHub>?
      requestsFromHubSubscription;

  static Stream<ConnectivityResult>? connectivityChangedStream;

  static bool areWeRunning = false;

  // static int numberOfCrashes = 0;
  static int numberOfConnactivityChange = 0;

  static Future<void> navigateRequest() async {
    if (areWeRunning) {
      return;
    }

    await Future.delayed(const Duration(milliseconds: 100));

    if (areWeRunning) {
      return;
    }
    areWeRunning = true;

    // await requestsFromHubSubscription?.cancel();
    // requestsFromHubSubscription = null;
    connectivityChangedStream = null;

    requestsFromHubSubscription = HubRequestsToApp
        .hubRequestsStreamBroadcast.stream
        .listen((RequestsAndStatusFromHub requestsAndStatusFromHub) {
      if (requestsAndStatusFromHub.sendingType == SendingType.entityType) {
        navigateDeviceRequest(requestsAndStatusFromHub.allRemoteCommands);
      } else if (requestsAndStatusFromHub.sendingType == SendingType.roomType) {
        navigateRoomRequest(requestsAndStatusFromHub.allRemoteCommands);
      } else if (requestsAndStatusFromHub.sendingType ==
          SendingType.sceneType) {
        navigateSceneRequest(requestsAndStatusFromHub.allRemoteCommands);
      } else {
        logger.i(
          'Got from Hub unsupported massage type: '
          '${requestsAndStatusFromHub.sendingType}',
        );
      }
    });
    requestsFromHubSubscription?.onError((error) async {
      if (error is GrpcError && error.code == 1) {
        logger.v('Hub have been disconnected');
      }
      // else if (error is GrpcError && error.code == 2) {
      //   logger.v('Hub have been terminated');
      // }
      else {
        logger.e('Hub stream error: $error');
        if (error.toString().contains('errorCode: 10')) {
          areWeRunning = false;

          navigateRequest();
        }
      }
    });

    connectivityChangedStream = Connectivity().onConnectivityChanged;
    connectivityChangedStream?.listen((ConnectivityResult event) async {
      numberOfConnactivityChange++;
      logger.i('Connectivity changed ${event.name} And $event');
      if (event == ConnectivityResult.none || numberOfConnactivityChange <= 1) {
        return;
      }
      areWeRunning = false;
      navigateRequest();
    });

    await getIt<IHubConnectionRepository>().connectWithHub();
  }

  static Future<void> navigateRoomRequest(
    String allRemoteCommands,
  ) async {
    final Map<String, dynamic> requestAsJson =
        jsonDecode(allRemoteCommands) as Map<String, dynamic>;

    final RoomEntityDtos roomEntityDtos = RoomEntityDtos(
      uniqueId: requestAsJson['uniqueId'] as String,
      cbjEntityName: requestAsJson['cbjEntityName'] as String,
      background: requestAsJson['background'] as String,
      roomTypes: List<String>.from(requestAsJson['roomTypes'] as List<dynamic>),
      roomDevicesId:
          List<String>.from(requestAsJson['roomDevicesId'] as List<dynamic>),
      roomScenesId:
          List<String>.from(requestAsJson['roomScenesId'] as List<dynamic>),
      roomRoutinesId:
          List<String>.from(requestAsJson['roomRoutinesId'] as List<dynamic>),
      roomBindingsId:
          List<String>.from(requestAsJson['roomBindingsId'] as List<dynamic>),
      roomMostUsedBy:
          List<String>.from(requestAsJson['roomMostUsedBy'] as List<dynamic>),
      roomPermissions:
          List<String>.from(requestAsJson['roomPermissions'] as List<dynamic>),
    );

    final RoomEntity roomEntity = roomEntityDtos.toDomain();
    getIt<IRoomRepository>().addOrUpdateRoom(roomEntity);
  }

  static Future<void> navigateDeviceRequest(
    String allRemoteCommands,
  ) async {
    final Map<String, dynamic> requestAsJson =
        jsonDecode(allRemoteCommands) as Map<String, dynamic>;
    final String? deviceTypeAsString = requestAsJson['entityTypes'] as String?;

    final String? deviceStateAsString =
        requestAsJson['entityStateGRPC'] as String?;
    if (deviceTypeAsString == null || deviceStateAsString == null) {
      return;
    }

    ///TODO: add request type login support

    final EntityTypes? deviceType =
        EnumHelperCbj.stringToDt(deviceTypeAsString);

    final EntityStateGRPC? entityStateGRPC =
        EnumHelperCbj.stringToDeviceState(deviceStateAsString);

    if (deviceType == null || entityStateGRPC == null) {
      return;
    }

    late DeviceEntityAbstract deviceEntity;

    switch (deviceType) {
      case EntityTypes.light:
        deviceEntity =
            GenericLightDeviceDtos.fromJson(requestAsJson).toDomain();
        logger.i('Adding Light device type');
      case EntityTypes.dimmableLight:
        deviceEntity =
            GenericDimmableLightDeviceDtos.fromJson(requestAsJson).toDomain();
        logger.i('Adding Dimmable Light device type');
      case EntityTypes.rgbwLights:
        deviceEntity =
            GenericRgbwLightDeviceDtos.fromJson(requestAsJson).toDomain();
        logger.i('Adding rgbW light device type');
      case EntityTypes.blinds:
        deviceEntity =
            GenericBlindsDeviceDtos.fromJson(requestAsJson).toDomain();
        logger.i('Adding Blinds device type');
      case EntityTypes.boiler:
        deviceEntity =
            GenericBoilerDeviceDtos.fromJson(requestAsJson).toDomain();
        logger.i('Adding Boiler device type');
      case EntityTypes.smartTV:
        deviceEntity =
            GenericSmartTvDeviceDtos.fromJson(requestAsJson).toDomain();
        logger.i('Adding Smart TV device type');
      case EntityTypes.switch_:
        deviceEntity =
            GenericSwitchDeviceDtos.fromJson(requestAsJson).toDomain();
        logger.i('Adding Switch device type');
      case EntityTypes.smartPlug:
        deviceEntity =
            GenericSmartPlugDeviceDtos.fromJson(requestAsJson).toDomain();
        logger.i('Adding Smart Plug device type');
      case EntityTypes.smartComputer:
        deviceEntity =
            GenericSmartComputerDeviceDtos.fromJson(requestAsJson).toDomain();
        logger.i('Adding Smart Plug device type');
      case EntityTypes.printer:
        deviceEntity =
            GenericPrinterDeviceDtos.fromJson(requestAsJson).toDomain();
        logger.i('Adding Smart printer device type');
      default:
        if (entityStateGRPC == EntityStateGRPC.pingNow) {
          deviceEntity =
              GenericPingDeviceDtos.fromJson(requestAsJson).toDomain();
          logger.v('Got Ping request');
          return;
        } else {
          deviceEntity =
              GenericEmptyDeviceDtos.fromJson(requestAsJson).toDomain();
          logger.w(
              'Device type is $deviceType is not supported $entityStateGRPC ',);
        }
        break;
    }

    getIt<IDeviceRepository>().addOrUpdateDevice(deviceEntity);
  }

  static Future<void> navigateSceneRequest(
    String allRemoteCommands,
  ) async {
    final Map<String, dynamic> requestAsJson =
        jsonDecode(allRemoteCommands) as Map<String, dynamic>;
    final SceneCbjDtos sceneCbjDtos = SceneCbjDtos.fromJson(requestAsJson);

    getIt<ISceneCbjRepository>()
        .addOrUpdateNewSceneInApp(sceneCbjDtos.toDomain());
  }
}
