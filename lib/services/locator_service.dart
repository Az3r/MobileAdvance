import 'package:get_it/get_it.dart';
import 'user_service.dart';
import 'video_service.dart';

class LocatorService {
  LocatorService._();
  static final LocatorService instance = LocatorService._();
  factory LocatorService() => instance;

  final locator = GetIt.instance;

  /// register all singleton services.
  /// calling this again does nothing
  Future<void> register() async {
    locator.registerSingletonAsync(() async => UserService());
    locator.registerSingletonAsync(
      () async => VideoService(),
      dispose: (param) => param.dispose(),
    );

    return locator.allReady();
  }

  UserService get users => locator.get<UserService>();
  VideoService get youtube => locator.get<VideoService>();
}
