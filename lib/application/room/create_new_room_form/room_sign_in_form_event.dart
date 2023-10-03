part of 'room_sign_in_form_bloc.dart';

@freezed
class RoomSignInFormEvent with _$RoomSignInFormEvent {
  const factory RoomSignInFormEvent.defaultNameChanged(String cbjEntityName) =
      DefaultNameChanged;

  const factory RoomSignInFormEvent.roomTypesChanged(
    List<String> roomTypes,
  ) = RoomTypesChanged;

  const factory RoomSignInFormEvent.roomIdChanged(
    String roomId,
  ) = RoomIdChanged;

  const factory RoomSignInFormEvent.roomDevicesIdChanged(
    List<String> roomDevicesId,
  ) = RoomDevicesIdChanged;

  const factory RoomSignInFormEvent.roomMostUsedByChanged(
    List<String> roomMostUsedBy,
  ) = RoomMostUsedByChanged;

  const factory RoomSignInFormEvent.roomPermissionsChanged(
    List<String> roomPermissions,
  ) = RoomPermissionsChanged;

  const factory RoomSignInFormEvent.changeRoomDevices(BuildContext context) =
      ChangeRoomDevices;

  const factory RoomSignInFormEvent.createRoom() = CreateRoom;

  const factory RoomSignInFormEvent.initialized() = Initialized;
}
