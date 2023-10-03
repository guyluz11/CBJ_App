import 'package:cybear_jinni/application/printers/printers_watcher/printers_watcher_bloc.dart';
import 'package:cybear_jinni/domain/generic_devices/abstract_device/device_entity_abstract.dart';
import 'package:cybear_jinni/domain/room/room_entity.dart';
import 'package:cybear_jinni/presentation/core/theme_data.dart';
import 'package:cybear_jinni/presentation/device_full_screen_page/printers/widgets/room_printers.dart';
import 'package:cybear_jinni/presentation/device_full_screen_page/smart_computers/widgets/critical_smart_computers_failure_display_widget.dart';
import 'package:cybear_jinni/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kt_dart/kt.dart';

class RoomsPrintersWidget extends StatelessWidget {
  const RoomsPrintersWidget(
    this.roomEntity,
    this.roomColorGradiant,
  );

  /// If not null show printers only from this room
  final RoomEntity roomEntity;

  final List<Color> roomColorGradiant;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrintersWatcherBloc, PrintersWatcherState>(
      builder: (context, state) {
        logger.v('Printers loadSuccess');

        return state.map(
          initial: (_) => Container(),
          loadInProgress: (_) => const Center(
            child: CircularProgressIndicator(),
          ),
          loadSuccess: (state) {
            if (state.devices.size != 0) {
              final Map<String, List<DeviceEntityAbstract>> tempDevicesByRooms =
                  <String, List<DeviceEntityAbstract>>{};

              /// Go on all the devices and find only the devices that exist
              /// in this room
              final String roomId = roomEntity.uniqueId.getOrCrash();
              for (final DeviceEntityAbstract? deviceEntityAbstract
                  in state.devices.iter) {
                if (deviceEntityAbstract == null) {
                  continue;
                }
                final int indexOfDeviceInRoom =
                    roomEntity.roomDevicesId.getOrCrash().indexWhere((element) {
                  return element == deviceEntityAbstract.uniqueId.getOrCrash();
                });
                if (indexOfDeviceInRoom != -1) {
                  if (tempDevicesByRooms[roomId] == null) {
                    tempDevicesByRooms[roomId] = [deviceEntityAbstract];
                  } else {
                    tempDevicesByRooms[roomId]!.add(deviceEntityAbstract);
                  }
                }
              }
              final List<KtList<DeviceEntityAbstract>> devicesByRooms = [];

              tempDevicesByRooms.forEach((k, v) {
                devicesByRooms.add(v.toImmutableList());
              });

              int gradientColorCounter = -1;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                child: ListView.builder(
                  reverse: true,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    gradientColorCounter++;
                    List<Color> gradiantColor = GradientColors.sky;
                    if (roomColorGradiant != null) {
                      gradiantColor = roomColorGradiant;
                    } else if (gradientColorCounter >
                        gradientColorsList.length - 1) {
                      gradientColorCounter = 0;
                      gradiantColor = gradientColorsList[gradientColorCounter];
                    }
                    final devicesInRoom = devicesByRooms[index];

                    return RoomPrinters(
                      devicesInRoom,
                      gradiantColor,
                      roomEntity.cbjEntityName.getOrCrash(),
                      maxPrintersToShow: 50,
                    );
                  },
                  itemCount: devicesByRooms.length,
                ),
              );
            } else {
              return SingleChildScrollView(
                reverse: true,
                padding: const EdgeInsets.only(bottom: 15),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 30),
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/cbj_logo.png',
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Printers does not exist.',
                        style: TextStyle(
                          fontSize: 30,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
          loadFailure: (state) {
            return CriticalSwitchFailureDisplay(
              failure: state.devicesFailure,
            );
          },
          printersError: (PrintersError value) {
            return const Text('Error');
          },
        );
      },
    );
  }
}
