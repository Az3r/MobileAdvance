import 'package:SingularSight/models/video_model.dart';
import 'package:SingularSight/models/playlist_model.dart';
import 'package:SingularSight/models/channel_model.dart';
import 'package:SingularSight/services/video_service.dart';
import 'package:http/src/client.dart';

class StubVideoService implements VideoService {
  @override
  // TODO: implement client
  Client get client => throw UnimplementedError();

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  Future<ChannelModel> findChannelById(String channelId) {
    // TODO: implement findChannelById
    throw UnimplementedError();
  }

  @override
  Stream<ChannelModel> findChannels(List<String> channelIds) {
    // TODO: implement findChannels
    throw UnimplementedError();
  }

  @override
  Stream<ChannelModel> findFeaturedChannels(String channelId) {
    // TODO: implement findFeaturedChannels
    throw UnimplementedError();
  }

  @override
  Stream<PlaylistModel> findPlaylistByChannel(String channelId) {
    // TODO: implement findPlaylistByChannel
    throw UnimplementedError();
  }

  @override
  Stream<VideoModel> findVideosOfPlaylist(String playlistId) {
    // TODO: implement findVideosOfPlaylist
    throw UnimplementedError();
  }

  @override
  Stream<ChannelModel> getAllChannels() {
    // TODO: implement getAllChannels
    throw UnimplementedError();
  }

  @override
  Stream<PlaylistModel> getPlaylistDetails(List<String> playlistIds) {
    // TODO: implement getPlaylistDetails
    throw UnimplementedError();
  }

  @override
  Stream<PlaylistModel> searchPlaylists({
    String q,
    int pageSize = 40,
    int pageOffset = 0,
    String order = VideoService.orderViewCount,
  }) {
    // TODO: implement searchPlaylists
    throw UnimplementedError();
  }

  @override
  Future<VideoModel> getVideoDetails(String videoId) {
    // TODO: implement getVideoDetails
    throw UnimplementedError();
  }

  @override
  Stream<String> findVideoIdsByPlaylist(String playlistId) {
    // TODO: implement findVideoIdsByPlaylist
    throw UnimplementedError();
  }
}
