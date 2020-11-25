import 'dart:convert';
import 'dart:io';

import 'package:SingularSight/mocks/stub_video_serivce.dart';
import 'package:SingularSight/models/user_model.dart';
import 'package:SingularSight/models/video_model.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'user_service.dart';
import 'video_service.dart';

class LocatorService {
  LocatorService._();
  static final LocatorService instance = LocatorService._();
  factory LocatorService() => instance;

  final locator = GetIt.instance;

  /// register all singleton services.
  ///
  /// set [samples] to true if you want to load all the sample data for testing
  Future<void> register({bool samples = false}) async {
    locator.registerSingletonAsync(() async => UserService());
    locator.registerSingletonAsync<VideoService>(
      () async => VideoService(),
      dispose: (param) => param.dispose(),
    );

    // register sample data
    locator.registerFactoryAsync<List<Map<String, dynamic>>>(_loadVideos);
    locator.registerFactoryAsync<UserModel>(() => null);
    return locator.allReady();
  }

  UserService get users => locator.get<UserService>();
  VideoService get youtube => locator.get<VideoService>();
  Future<List<Map<String, dynamic>>> get videos =>
      locator.getAsync<List<Map<String, dynamic>>>();
}

Future<List<Map<String, dynamic>>> _loadVideos() async {
  return rootBundle.loadStructuredData(
    'assets/samples/videos.json',
    (value) async => jsonDecode(value,
            reviver: (i, item) => jsonDecode(item) as Map<String, dynamic>)
        as List<Map<String, dynamic>>,
  );
}
