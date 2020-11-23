import 'package:SingularSight/utilities/keys.dart' as keys;
import 'package:get_it/get_it.dart';
import 'package:youtube_data_v3/youtube_data_v3.dart';
import 'user_service.dart';

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
      locator
          .registerSingletonAsync(() async => YoutubeV3()..init(keys.youtube));

      return locator.allReady();
    }
  }

  Future<UserService> get users => locator.getAsync<UserService>();
  Future<YoutubeV3> get youtube => locator.getAsync<YoutubeV3>();
}
