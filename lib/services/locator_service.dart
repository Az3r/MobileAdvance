import 'dart:convert';
import 'dart:io';

import 'package:SingularSight/mocks/stub_video_serivce.dart';
import 'package:SingularSight/models/user_model.dart';
import 'package:SingularSight/models/video_model.dart';
import 'package:flutter/foundation.dart';
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
  Future<void> register() async {
    locator.registerSingletonAsync(() async => UserService());
    locator.registerSingletonAsync<VideoService>(
      () async => StubVideoService(),
      dispose: (param) => param.dispose(),
    );

    // register sample data
    locator.registerFactoryAsync<List<VideoModel>>(_loadVideos);
    locator.registerFactoryAsync<UserModel>(() => null);
    return locator.allReady();
  }

  UserService get users => locator.get<UserService>();
  VideoService get youtube => locator.get<VideoService>();
  Future<List<VideoModel>> get videos => locator.getAsync<List<VideoModel>>();
}

Future<List<VideoModel>> _loadVideos() async {
  final data = await rootBundle.loadStructuredData<String>(
      'assets/samples/videos.json', (value) async => value);

  return compute<String, List<VideoModel>>(_parseVideos, data);
}

List<VideoModel> _parseVideos(String data) {
  final parsed = jsonDecode(data).cast<Map<String, dynamic>>();
  return parsed.map<VideoModel>((json) => VideoModel.fromJson(json)).toList();
}
