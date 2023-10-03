import 'package:auto_size_text/auto_size_text.dart';
import 'package:cybear_jinni/application/boilers/boilers_actor/boilers_actor_bloc.dart';
import 'package:cybear_jinni/domain/generic_devices/abstract_device/device_entity_abstract.dart';
import 'package:cybear_jinni/domain/generic_devices/generic_boiler_device/generic_boiler_entity.dart';
import 'package:cybear_jinni/injection.dart';
import 'package:cybear_jinni/presentation/device_full_screen_page/boilers/widgets/boilers_widget.dart';
import 'package:cybear_jinni/presentation/device_full_screen_page/boilers/widgets/error_boilers_device_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kt_dart/collection.dart';

/// Show boiler toggles in a container with the background color from smart room
/// object
class RoomBoilers extends StatelessWidget {
  const RoomBoilers(
    this._deviceEntityList,
    this._gradientColor,
    this._roomEntity, {
    this.maxBoilersToShow = 4,
  });

  final KtList<DeviceEntityAbstract?>? _deviceEntityList;

  final int? maxBoilersToShow;

  final int _maxBoilersInRow = 2;

  final String? _roomEntity;

  final List<Color> _gradientColor;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double sizeBoxWidth = screenSize.width * 0.25;

    Widget? createSwitchTableWidget() {
      final List<Widget> columnOfBoilers = <Widget>[];
      List<Widget>? widgetsForRow = <Widget>[];

      final int? numberOfBoilersToShow =
          _deviceEntityList!.size > maxBoilersToShow!
              ? maxBoilersToShow
              : _deviceEntityList!.size;

      for (int i = 0; i < numberOfBoilersToShow!; i += _maxBoilersInRow) {
        for (int v = 0; v < _maxBoilersInRow; v++) {
          if (_deviceEntityList!.size > i + v) {
            final GenericBoilerDE? deviceEntityTemp;

            if (_deviceEntityList![i + v] is! GenericBoilerDE) {
              continue;
            }

            deviceEntityTemp = _deviceEntityList![i + v]! as GenericBoilerDE;

            if (deviceEntityTemp.failureOption.isSome()) {
              widgetsForRow!
                  .add(ErrorBoilersDeviceCard(device: deviceEntityTemp));
            } else {
              widgetsForRow!.add(
                Column(
                  children: [
                    AutoSizeText(
                      deviceEntityTemp.cbjEntityName.getOrCrash()!,
                      maxLines: 1,
                      maxFontSize: 19,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      width: sizeBoxWidth + 15,
                      child: BlocProvider(
                        create: (context) => getIt<BoilersActorBloc>(),
                        child: BoilersWidget(deviceEntityTemp),
                      ),
                    ),
                  ],
                ),
              );
            }
          } else {
            widgetsForRow!.add(
              const SizedBox(
                width: 110,
              ),
            );
          }
        }
        final Widget rowOfBoilers = Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: widgetsForRow!,
        );
        widgetsForRow = <Widget>[];
        columnOfBoilers.add(rowOfBoilers);
      }
      columnOfBoilers.add(
        const SizedBox(
          height: 5,
        ),
      );

      return Column(
        children: columnOfBoilers,
      );
    }

    return Container(
      margin: EdgeInsets.only(bottom: screenSize.height * 0.02),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _gradientColor,
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
                if (maxBoilersToShow != null &&
                    _deviceEntityList!.size > maxBoilersToShow!) {
                  // ExtendedNavigator.of(context).pushBoilersInTheRoomPage(
                  //     thisSmartRoom: _deviceEntityList);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    _roomEntity!,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      fontSize: 25,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  if (maxBoilersToShow != null &&
                      _deviceEntityList!.size > maxBoilersToShow!)
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
            createSwitchTableWidget()!,
          ],
        ),
      ),
    );
  }
}
