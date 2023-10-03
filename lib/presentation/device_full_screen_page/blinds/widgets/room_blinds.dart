import 'package:auto_size_text/auto_size_text.dart';
import 'package:cybear_jinni/application/blinds/blinds_actor/blinds_actor_bloc.dart';
import 'package:cybear_jinni/domain/generic_devices/abstract_device/device_entity_abstract.dart';
import 'package:cybear_jinni/domain/generic_devices/generic_blinds_device/generic_blinds_entity.dart';
import 'package:cybear_jinni/injection.dart';
import 'package:cybear_jinni/presentation/device_full_screen_page/blinds/widgets/blind_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kt_dart/collection.dart';

/// Show light toggles in a container with the background color from smart room
/// object
class RoomBlinds extends StatelessWidget {
  const RoomBlinds(
    this._deviceEntityList,
    this._gradientColor,
    this._roomEntity, {
    this.maxLightsToShow = 4,
  });

  final KtList<DeviceEntityAbstract> _deviceEntityList;

  final int maxLightsToShow;

  final String _roomEntity;

  final List<Color>? _gradientColor;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    Widget createSwitchTableWidget() {
      final List<Widget> columnOfLights = <Widget>[];

      final int numberOfBlindsToShow = _deviceEntityList.size;

      for (int i = 0; i < numberOfBlindsToShow; i++) {
        GenericBlindsDE deviceEntityTemp;
        if (_deviceEntityList[i] is! GenericBlindsDE) {
          continue;
        }
        deviceEntityTemp = _deviceEntityList[i] as GenericBlindsDE;

        columnOfLights.add(
          Column(
            children: [
              AutoSizeText(
                deviceEntityTemp.cbjEntityName.getOrCrash()!,
                maxLines: 1,
                maxFontSize: 19,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: BlocProvider(
                  create: (context) => getIt<BlindsActorBloc>(),
                  child: BlindWidget(deviceEntityTemp),
                ),
              ),
            ],
          ),
        );

        columnOfLights.add(
          const SizedBox(
            height: 5,
          ),
        );
      }

      return Column(
        children: columnOfLights,
      );
    }

    return Container(
      margin: EdgeInsets.only(bottom: screenSize.height * 0.02),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _gradientColor!,
          begin: Alignment.bottomLeft,
          end: Alignment.topLeft,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        border: Border.all(
          color: Theme.of(context).textTheme.bodyLarge!.color!,
          width: 0.6,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.black.withOpacity(0.2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(2),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.transparent,
                ),
              ),
              onPressed: () {
                if (_deviceEntityList.size > maxLightsToShow) {
                  // ExtendedNavigator.of(context).pushLightsInTheRoomPage(
                  //     thisSmartRoom: _deviceEntityList);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    _roomEntity,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      fontSize: 25,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  if (_deviceEntityList.size > maxLightsToShow)
                    FaIcon(
                      FontAwesomeIcons.arrowRight,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      size: 20,
                    ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(5),
            ),
            createSwitchTableWidget(),
          ],
        ),
      ),
    );
  }
}
