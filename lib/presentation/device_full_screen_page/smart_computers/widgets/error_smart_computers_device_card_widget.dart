import 'package:cybear_jinni/domain/generic_devices/generic_smart_computer_device/generic_smart_computer_entity.dart';
import 'package:flutter/material.dart';

class ErrorSmartComputersDeviceCard extends StatelessWidget {
  const ErrorSmartComputersDeviceCard({
    required this.device,
    super.key,
  });

  final GenericSmartComputerDE? device;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.error,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: <Widget>[
            Text(
              'Invalid device, please, contact support',
              style: Theme.of(context).primaryTextTheme.bodyMedium!
                  .copyWith(fontSize: 18),
            ),
            const SizedBox(height: 2),
            Text(
              'Details for nerds:',
              style: Theme.of(context).primaryTextTheme.bodyMedium,
            ),
            Text(
              device!.failureOption.fold(() => '', (f) => f.toString()),
              style: Theme.of(context).primaryTextTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
