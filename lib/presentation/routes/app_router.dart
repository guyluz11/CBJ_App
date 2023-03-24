import 'package:auto_route/auto_route.dart';
import 'package:cybear_jinni/presentation/routes/app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  final List<AutoRoute> routes = [
    AutoRoute(page: SplashRoute.page, path: '/'),
    AutoRoute(page: IntroductionRouteRoute.page),
    AutoRoute(page: ConnectToHubRoute.page),
    AutoRoute(page: ConnectToHubMoreRoute.page),
    AutoRoute(page: SignInRoute.page),
    AutoRoute(page: CreateHomeRoute.page),
    AutoRoute(page: WhereToLoginRouteMinimalRoute.page),
    AutoRoute(page: WhereToLoginRouteOffline.page),
    AutoRoute(page: JoinHomeByIdRoute.page),
    AutoRoute(page: HomeRoute.page),
    AutoRoute(page: ChangeRoomForDevicesRoute.page),
    AutoRoute(page: AddNewRoomRoute.page),
    AutoRoute(page: PlusButtonRoute.page),
    AutoRoute(page: RemotePipesRoute.page),
    AutoRoute(page: SoftwareInfoRoute.page),
    AutoRoute(page: ManageUsersRoute.page),
    AutoRoute(page: AddUserToHomeRoute.page),
    AutoRoute(page: ScenesRoute.page),
    AutoRoute(page: AddSceneRoute.page),
    AutoRoute(page: AddRoutineRoute.page),
    AutoRoute(page: PickRepeatTimeRoute.page),
    AutoRoute(page: AddBindingRoute.page),
    AutoRoute
        // <List<MapEntry<DeviceEntityAbstract, MapEntry<String?, String?>>>>
        (
      page: AddActionRoute.page,
    ),
    AutoRoute(page: ChooseAutomationTypeToAddRoute.page),
    AutoRoute(page: ChooseDeviceVendorToAddRoute.page),
    AutoRoute(page: AddLifxVendorRoute.page),
    AutoRoute(page: AddEspHomeVendorRoute.page),
    AutoRoute(page: AddTuyaVendorRoute.page),
    AutoRoute(page: AddSmartLifeVendorRoute.page),
    AutoRoute(page: AddJinvooSmartVendorRoute.page),
    AutoRoute(page: ConnectToHomeWifiRoute.page),
    AutoRoute(page: OpenAccessPointRoute.page),
    AutoRoute(page: ScanForNewCBJCompsRoute.page),
    AutoRoute(page: ConfigureNewCbjCompRoute.page),
    AutoRoute(page: ComputerConnectionCheckRoute.page),
    AutoRoute(page: RoomsLightsRoute.page),
    AutoRoute(page: LightsInTheRoomRoute.page),
    AutoRoute(page: RoomsSwitchesRoute.page),
    AutoRoute(page: RoomsSmartComputersRoute.page),
    AutoRoute(page: RoomsSmartTvsRoute.page),
    AutoRoute(page: RoomsPrintersRoute.page),
    AutoRoute(page: SwitchesInTheRoomRoute.page),
    AutoRoute(
      page: RoomsSmartPlugsRoute.page,
    ),
    AutoRoute(page: SmartPlugsInTheRoomRoute.page),
    AutoRoute(page: RoomsBlindsRoute.page),
    AutoRoute(page: RoomsBoilersRoute.page),
  ];
}
