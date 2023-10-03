import 'package:cybear_jinni/domain/room/smart_room_object.dart';
import 'package:cybear_jinni/presentation/device_full_screen_page/boilers/smart_boiler_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Show boiler toggles in a container with the background color from smart room
/// object
class RoomBoilersTogglesBlock extends StatelessWidget {
  const RoomBoilersTogglesBlock(this._smartRoomObject, {this.maxBoilersToShow});

  final SmartRoomObject? _smartRoomObject;

  final int? maxBoilersToShow;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double sizeBoxWidth = screenSize.width * 0.25;

    /// Creates column of rows of boiler switches
    Widget createSwitchTableWidget() {
      final List<Widget> columnOfBoilers = <Widget>[];
      List<Widget> widgetsForRow = <Widget>[];
      const int maxBoilersInRow = 2;
      int numberOfBoilersToShow;
      if (maxBoilersToShow != null &&
          maxBoilersToShow! <= _smartRoomObject!.getBoilers()!.length) {
        numberOfBoilersToShow = maxBoilersToShow!;
      } else {
        numberOfBoilersToShow = _smartRoomObject!.getBoilers()!.length;
      }

      for (int i = 0; i < numberOfBoilersToShow; i += maxBoilersInRow) {
        for (int v = 0; v < maxBoilersInRow; v++) {
          if (_smartRoomObject!.getBoilers()!.length > i + v) {
            widgetsForRow.add(
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                width: sizeBoxWidth + 15,
                child: SmartBoilerPage(
                  _smartRoomObject!.getBoilers()![i + v],
                ),
              ),
            );
          } else {
            widgetsForRow.add(
              const SizedBox(
                width: 110,
              ),
            );
          }
        }
        final Widget rowOfBoilers = Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: widgetsForRow,
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
          colors: _smartRoomObject!.grediantColor,
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
                // if (maxBoilersToShow != null &&
                //     _smartRoomObject.getBoilers().length > maxBoilersToShow) {
                //   ExtendedNavigator.of(context).pushBoilersInTheRoomPage(
                //       thisSmartRoom: _smartRoomObject);
                // }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    _smartRoomObject!.getRoomName(),
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      fontSize: 25,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  if (maxBoilersToShow != null &&
                      _smartRoomObject!.getBoilers()!.length >
                          maxBoilersToShow!)
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
