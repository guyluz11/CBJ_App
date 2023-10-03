import 'package:cybear_jinni/domain/local_db/local_db_failures.dart';
import 'package:dartz/dartz.dart';

abstract class ILocalDbRepository {
  String remotePipesBoxName = 'remotePipesBox';
  String hubEntityBoxName = 'hubEntityBox';

  Future<void> setHomeId(String homeId);

  Future<String> getHomeId();

  Future<Either<LocalDbFailures, Unit>> saveRemotePipes({
    required String remotePipesDomainName,
  });

  Future<Either<LocalDbFailures, Unit>> saveHubEntity({
    required String hubNetworkBssid,
    required String networkName,
    required String lastKnownIp,
  });

  Future<Either<LocalDbFailures, String>> getRemotePipesDnsName();

  Future<Either<LocalDbFailures, String>> getHubEntityNetworkBssid();

  Future<Either<LocalDbFailures, String>> getHubEntityNetworkName();

  Future<Either<LocalDbFailures, String>> getHubEntityLastKnownIp();
}
