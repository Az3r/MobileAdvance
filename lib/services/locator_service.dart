import 'package:SingularSight/utilities/globals.dart';
import 'package:get_it/get_it.dart';

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
      return locator.allReady();
    }
  }

  Future<UserService> get users => locator.getAsync<UserService>();
}
