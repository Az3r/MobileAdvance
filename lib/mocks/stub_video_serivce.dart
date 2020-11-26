import 'package:SingularSight/models/playlist_model.dart';
import 'package:SingularSight/models/video_model.dart';
import 'package:SingularSight/services/locator_service.dart';
import 'package:SingularSight/services/video_service.dart';

class StubVideoService implements VideoService {
  @override
  // TODO: implement client
  get client => throw UnimplementedError();

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  Stream<VideoModel> findVideosByChannel(String channelId) async* {
    for (final item in await LocatorService().videos) yield item;
  }

  @override
  Stream<PlaylistModel> searchPlaylists(String query) {
    // TODO: implement searchPlaylists
    throw UnimplementedError();
  }
}
