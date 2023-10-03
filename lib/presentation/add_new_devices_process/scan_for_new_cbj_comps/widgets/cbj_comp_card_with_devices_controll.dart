import 'package:auto_route/auto_route.dart';
import 'package:cybear_jinni/application/devices/device_actor/device_actor_bloc.dart';
import 'package:cybear_jinni/domain/cbj_comp/cbj_comp_entity.dart';
import 'package:cybear_jinni/domain/generic_devices/generic_light_device/generic_light_entity.dart';
import 'package:cybear_jinni/infrastructure/core/gen/cbj_hub_server/protoc_as_dart/cbj_hub_server.pbgrpc.dart';
import 'package:cybear_jinni/injection.dart';
import 'package:cybear_jinni/presentation/routes/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kt_dart/kt.dart';

class CBJCompCardWithDevicesControll extends StatelessWidget {
  const CBJCompCardWithDevicesControll({
    required this.cbjCompEntity,
  });

  final CBJCompEntity cbjCompEntity;

  Widget devicesTypes(BuildContext context) {
    final List<Widget> typesList = [];
    final KtList<GenericLightDE> deviceEntityList =
        cbjCompEntity.cBJCompDevices!.getOrCrash();

    for (final GenericLightDE deviceEntity in deviceEntityList.asList()) {
      //
      if (deviceEntity.entityTypes.getOrCrash() !=
          EntityTypes.smartTypeNotSupported.toString()) {
        typesList.add(
          ColoredBox(
            color: Colors.yellowAccent.withOpacity(0.3),
            child: BlocProvider(
              create: (context) => getIt<DeviceActorBloc>(),
              child: Text(
                'Type: ${deviceEntity.entityTypes.getOrCrash()}',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
            ),
          ),
        );
      } else {
        typesList.add(
          ColoredBox(
            color: Colors.orange.withOpacity(0.3),
            child: Text(
              'Type ${deviceEntity.entityTypes.getOrCrash()} is not supported',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
          ),
        );
      }
    }
    if (typesList.isEmpty) {
      typesList.add(const Text('Computer does not contain any devices'));
    }

    final Column deviceColumn = Column(
      children: typesList.toList(),
    );

    return deviceColumn;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceActorBloc, DeviceActorState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.all(15.0),
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).textTheme.bodyLarge!.color!,
            ),
            color: Colors.purpleAccent.withOpacity(0.2),
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(context).textTheme.bodyLarge!.color!,
                    ),
                    bottom: BorderSide(
                      color: Theme.of(context).textTheme.bodyLarge!.color!,
                    ),
                  ),
                ),
                child: devicesTypes(context),
              ),
              const SizedBox(
                height: 30,
              ),
              state.map(
                initial: (_) => Text(
                  'Initial',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
                actionInProgress: (_) => Text(
                  'actionInProgress',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
                deleteFailure: (_) => Text(
                  'deleteFailure',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
                deleteSuccess: (_) => Text(
                  'deleteSuccess',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.greenAccent,
                  ),
                ),
                onPressed: () {
                  context.router.replace(
                    ConfigureNewCbjCompRoute(cbjCompEntity: cbjCompEntity),
                  );
                },
                child: Text(
                  'Set up computer',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
// CBJCompBloc
