import 'package:cybear_jinni/domain/add_user_to_home/add_user_to_home_errors.dart';
import 'package:cybear_jinni/domain/add_user_to_home/add_user_to_home_failures.dart';
import 'package:cybear_jinni/domain/add_user_to_home/i_add_user_to_home_repository.dart';
import 'package:cybear_jinni/domain/home_user/home_user_entity.dart';
import 'package:cybear_jinni/domain/local_db/i_local_db_repository.dart';
import 'package:cybear_jinni/infrastructure/home_user/home_user_dtos.dart';
import 'package:cybear_jinni/injection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IAddUserToHomeRepository)
class AddUserToHomeRepository implements IAddUserToHomeRepository {
  AddUserToHomeRepository(this._firestore);

  final String _firestore;

  @override
  @required
  Future<Either<AddUserToHomeFailures, Unit>> create(
    HomeUserEntity homeUserEntity,
  ) async {
    try {
      // final devicesDoc = await _firestore.currentHomeDocument();
      //
      final String userId = homeUserEntity.id!.getOrCrash()!;
      // final String userName = addUserToHomeEntity.name.getOrCrash();
      // final String userEmail = addUserToHomeEntity.email.getOrCrash();

      final HomeUserDtos homeUserDtos = HomeUserDtos.fromDomain(homeUserEntity);

      // await devicesDoc.usersCollecttion.doc(userId).set(homeUserDtos.toJson());
      return right(unit);
    } on PlatformException catch (e) {
      if (e.message!.contains('PERMISSION_DENIED')) {
        return left(const AddUserToHomeFailures.insufficientPermission());
      } else {
        // log.error(e.toString());
        return left(const AddUserToHomeFailures.unexpected());
      }
    }
  }

  Future<Either<AddUserToHomeFailures, Map<String, dynamic>>> getUserByEmail(
    String email,
  ) async {
    try {
      // final devicesDoc = await _firestore.usersCollection();
      // final QuerySnapshot querySnapshot =
      //     await devicesDoc.where('email', isEqualTo: email).snapshots().first;
      // final List<QueryDocumentSnapshot> queryDocSnapList = querySnapshot.docs;
      // final QueryDocumentSnapshot queryDocSnap = queryDocSnapList.first;
      // return right(queryDocSnap);
    } on PlatformException catch (e) {
      if (e.message!.contains('PERMISSION_DENIED')) {
        return left(const AddUserToHomeFailures.insufficientPermission());
      } else {
        // log.error(e.toString());
        return left(const AddUserToHomeFailures.unexpected());
      }
    }
    return left(const AddUserToHomeFailures.unexpected());
  }

  @override
  Future<Either<AddUserToHomeFailures, String>> add(
    HomeUserEntity homeUserEntity,
  ) async {
    try {
      final Either<AddUserToHomeFailures, Map<String, dynamic>>
          userDocOrFailure =
          await getUserByEmail(homeUserEntity.email!.getOrCrash()!);
      final Map<String, dynamic> userDocument = userDocOrFailure.fold(
        (f) => throw AddUserToHomeUnexpectedValueError(f),
        (r) => r,
      );

      //   required AddUserToHomeEmail email,
      // required AddUserToHomeName name,
      // required AddUserToHomePermission permission,
      //
      // final HomeUserEntity homeUserEntityToAdd = homeUserEntity.copyWith(
      //   id: HomeUserUniqueId.fromUniqueString(userDocument.id),
      //   name: HomeUserName(userDocument.get('name').toString()),
      //   email: HomeUserEmail(userDocument.get('email').toString()),
      // );

      // await create(homeUserEntityToAdd);
      final String homeId = await getIt<ILocalDbRepository>().getHomeId();
      return Right(homeId);
    } catch (e) {
      return const Left(AddUserToHomeFailures.unexpected());
    }
  }
}
