import 'package:cybear_jinni/domain/generic_devices/generic_light_device/generic_light_entity.dart';
import 'package:cybear_jinni/infrastructure/core/gen/cbj_hub_server/protoc_as_dart/cbj_hub_server.pbgrpc.dart';

import 'package:cybear_jinni/infrastructure/objects/enums_cbj.dart';
import 'package:cybear_jinni/presentation/device_full_screen_page/lights/smart_lighte_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Show bar of device type with toggle switch for light
class SmartDeviceTypeAndToggleBar extends StatelessWidget {
  const SmartDeviceTypeAndToggleBar(this._smartDeviceObject);

  final GenericLightDE _smartDeviceObject;

  @override
  Widget build(BuildContext context) {
    final EntityTypes deviceType =
        EnumHelperCbj.stringToDt(_smartDeviceObject.entityTypes.getOrCrash())!;
    return Row(
      children: <Widget>[
        if (deviceType == EntityTypes.light)
          Container(
            margin: const EdgeInsets.only(right: 5),
            child: const CircleAvatar(
              radius: 16,
              child: FaIcon(FontAwesomeIcons.solidLightbulb),
            ),
          ),
        if (deviceType == EntityTypes.blinds)
          Container(
            margin: const EdgeInsets.only(right: 5),
            child: const CircleAvatar(
              radius: 16,
              child: FaIcon(FontAwesomeIcons.satelliteDish),
            ),
          ),
        Text(
          'Device_type:_',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).textTheme.bodyLarge!.color,
            backgroundColor: Colors.blueGrey
//                color: (Theme.of(context).textTheme.bodyLarge!.color)!,
            ,
          ),
        ).tr(args: <String>[EnumHelperCbj.dTToString(deviceType)]),
        if (deviceType == EntityTypes.light)
          SizedBox(
            width: 100,
            child: SmartLightPage(
              _smartDeviceObject,
            ), // The actual render of the device
          )
        else
          Container(),
      ],
    );
  }
}
