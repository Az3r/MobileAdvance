import 'package:SingularSight/models/channel_model.dart';
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

  @override
  Future<ChannelModel> findChannelById(String channelId) {
    // TODO: implement findChannelById
    throw UnimplementedError();
  }

  @override
  Stream<ChannelModel> findFeaturedChannels(String channelId) {
    // TODO: implement findFeaturedChannels
    throw UnimplementedError();
  }

  @override
  Stream<ChannelModel> findChannels(List<String> channelIds) {
    // TODO: implement findChannels
    throw UnimplementedError();
  }

  @override
  Stream<ChannelModel> getAllChannels() {
    // TODO: implement getAllChannels
    throw UnimplementedError();
  }

  @override
  Stream<VideoModel> getVideoDetails(List<String> videoIds) {
    // TODO: implement getVideoDetails
    throw UnimplementedError();
  }
}
