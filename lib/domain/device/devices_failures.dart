import 'package:freezed_annotation/freezed_annotation.dart';

part 'devices_failures.freezed.dart';

@freezed
class DevicesFailure<T> {
  const factory DevicesFailure.empty({
    required T failedValue,
  }) = _Empty;

  const factory DevicesFailure.actionExcecuter({
    required T failedValue,
  }) = _ActionExcecuter;

  const factory DevicesFailure.exceedingLength({
    required T failedValue,
    required int max,
  }) = _ExceedingLength;

  const factory DevicesFailure.unexpected() = _Unexpected;

  const factory DevicesFailure.insufficientPermission() =
      _InsufficientPermission;

  const factory DevicesFailure.unableToUpdate() = _UnableToUpdate;

  const factory DevicesFailure.powerConsumptionIsNotNumber() =
      _PowerConsumptionIsNotNumber;

  const factory DevicesFailure.deviceActionDoesNotExist() =
      _DeviceActionDoesNotExist;

  const factory DevicesFailure.deviceTypeDoesNotExist() =
      _DeviceTypeDoesNotExist;
}
