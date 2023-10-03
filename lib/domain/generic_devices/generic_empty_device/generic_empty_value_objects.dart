import 'package:cybear_jinni/domain/generic_devices/abstract_device/core_failures.dart';
import 'package:cybear_jinni/domain/generic_devices/abstract_device/value_objects_core.dart';
import 'package:cybear_jinni/domain/generic_devices/generic_empty_device/generic_empty_validators.dart';
import 'package:dartz/dartz.dart';

class GenericEmptySwitchState extends ValueObjectCore<String> {
  factory GenericEmptySwitchState(String? input) {
    return GenericEmptySwitchState._(
      validateGenericEmptyStateNotEmpty(input ?? 'false'),
    );
  }

  const GenericEmptySwitchState._(this.value);

  @override
  final Either<CoreFailure<String>, String> value;

  /// All valid actions of empty device state
  static List<String> emptyDeviceValidActions() {
    return emptyDeviceAllValidActions();
  }
}
