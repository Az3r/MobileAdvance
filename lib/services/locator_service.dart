import 'package:get_it/get_it.dart';
import 'user_service.dart';
import 'video_service.dart';

class LocatorService {
  LocatorService._();
  static final LocatorService instance = LocatorService._();
  bool _unregistered = true;
  factory LocatorService() => instance;

  final locator = GetIt.instance;

  /// register all singleton services.
  /// calling this again does nothing
  Future<void> register() async {
    if (_unregistered) {
      _unregistered = false;
      locator.registerSingletonAsync(() async => UserService());
      locator.registerSingletonAsync(
          () async => VideoService());

      return locator.allReady();
    }
  }

  Future<UserService> get users => locator.getAsync<UserService>();
  Future<VideoService> get youtube => locator.getAsync<VideoService>();
}
