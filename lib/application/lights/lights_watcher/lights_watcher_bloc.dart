import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cybear_jinni/domain/device/devices_failures.dart';
import 'package:cybear_jinni/domain/device/i_device_repository.dart';
import 'package:cybear_jinni/domain/generic_devices/abstract_device/device_entity_abstract.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/kt.dart';

part 'lights_watcher_bloc.freezed.dart';
part 'lights_watcher_event.dart';
part 'lights_watcher_state.dart';

@injectable
class LightsWatcherBloc extends Bloc<LightsWatcherEvent, LightsWatcherState> {
  LightsWatcherBloc(this._deviceRepository)
      : super(LightsWatcherState.initial()) {
    on<WatchAllStarted>(_watchAllStarted);
    on<DevicesReceived>(_devicesReceived);
  }

  final IDeviceRepository _deviceRepository;
  StreamSubscription<Either<DevicesFailure, KtList<DeviceEntityAbstract?>>>?
      _deviceStreamSubscription;

  Future<void> _watchAllStarted(
    WatchAllStarted event,
    Emitter<LightsWatcherState> emit,
  ) async {
    emit(const LightsWatcherState.loadInProgress());
    await _deviceStreamSubscription?.cancel();
    _deviceStreamSubscription = _deviceRepository.watchLights().listen(
          (eventWatch) => add(LightsWatcherEvent.devicesReceived(eventWatch)),
        );
  }

  Future<void> _devicesReceived(
    DevicesReceived event,
    Emitter<LightsWatcherState> emit,
  ) async {
    emit(const LightsWatcherState.loadInProgress());
    emit(
      event.failureOrDevices.fold(
        (f) => LightsWatcherState.loadFailure(f),
        (d) => LightsWatcherState.loadSuccess(
          d.map((v) => v!).toMutableList(),
        ),
      ),
    );
  }

  @override
  Future<void> close() async {
    await _deviceStreamSubscription?.cancel();
    return super.close();
  }
}
