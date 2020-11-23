import 'package:SingularSight/utilities/keys.dart' as keys;
import 'package:get_it/get_it.dart';
import 'package:googleapis/youtube/v3.dart' show YoutubeApi;
import 'package:googleapis_auth/auth_io.dart' show clientViaApiKey;
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
      locator.registerSingletonAsync(
          () async => YoutubeApi(clientViaApiKey(keys.youtube)));

      return locator.allReady();
    }
  }

  Future<UserService> get users => locator.getAsync<UserService>();
  Future<YoutubeApi> get youtube => locator.getAsync<YoutubeApi>();
}
