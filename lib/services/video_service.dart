
import 'package:SingularSight/models/channel_model.dart';
import 'package:SingularSight/models/playlist_model.dart';
import 'package:SingularSight/models/video_model.dart';
import 'package:SingularSight/utilities/duration_utils.dart';
import 'package:SingularSight/utilities/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import '../utilities/keys.dart' as keys;

class VideoService {
  static const String partSnippet = 'snippet';
  static const String partId = 'id';
  static const String partContentDetails = 'contentDetails';
  static const String partStatistics = 'statistics';
  static const String partBrandingSettings = 'brandingSettings';
  static const String orderRelevance = 'relevance';
  static const String regionVN = 'vn';

  final http.Client client;
  YoutubeApi _youtube;
  VideoService([String apiKey = keys.youtube])
      : client = clientViaApiKey(keys.youtube) {
    _youtube = YoutubeApi(client);
  }

  /// find all video related to a channel
  Stream<VideoModel> findVideosByChannel(String channelId) async* {
    final res = await _youtube.search.list(
      partSnippet,
      channelId: channelId,
      regionCode: regionVN,
      order: orderRelevance,
    );

    for (final item in res.items) {
      final snippet = item.snippet;
      final details = await _getVideoDetails(item.id.videoId);
      final model = VideoModel(
        channelId: snippet.channelId,
        channelTitle: htmlUnEscape.convert(snippet.channelTitle),
        description: htmlUnEscape.convert(snippet.description),
        id: item.id.videoId,
        publishedAt: snippet.publishedAt,
        thumbnails: snippet.thumbnails,
        title: htmlUnEscape.convert(snippet.title),
        duration: details['duration'],
        likeCount: details['like'],
        dislikeCount: details['dislike'],
        viewCount: details['view'],
      );
      log.v(model.toJson());
      yield model;
    }
  }

  /// search all playlists using the [query] for query term
  Stream<PlaylistModel> searchPlaylists(String query) async* {
    final res = await _youtube.search.list(
      '$partSnippet, $partId',
      q: query,
      order: orderRelevance,
      regionCode: regionVN,
    );

    for (final item in res.items) {
      final details = await _getPlaylistDetails(item.id.playlistId);
      final playlist = PlaylistModel(
        channelTitle: item.snippet.channelTitle,
        channelId: item.snippet.channelId,
        id: item.id.playlistId,
        thumbnails: item.snippet.thumbnails,
        title: item.snippet.title,
        videoCount: details['videoCount'],
      );
      log.v(playlist.toJson());
      yield playlist;
    }
  }

  /// Get all channels stored in cloud firestore
  Stream<ChannelModel> getAllChannels() async* {
    final query = await FirebaseFirestore.instance.collection('channels').get();
    final ids = query.docs.map((e) => e.id).toList();
    await for (final channel in findChannels(ids)) yield channel;
  }

  Future<ChannelModel> findChannelById(String channelId) async {
    final res = await _youtube.channels.list(
      '$partSnippet, $partId, $partStatistics',
      maxResults: 1,
      id: channelId,
    );

    final item = res.items.first;
    final channel = ChannelModel(
      id: channelId,
      description: item.snippet.description,
      profileColor: item.brandingSettings.channel.profileColor,
      subscriberCount: int.parse(item.statistics.subscriberCount),
      thumbnails: item.snippet.thumbnails,
      title: item.brandingSettings.channel.title,
      unsubscribedTrailer: item.brandingSettings.channel.unsubscribedTrailer,
    );
    log.v(channel.toJson());
    return channel;
  }

  Stream<ChannelModel> findChannels(List<String> channelIds) async* {
    final res = await _youtube.channels.list(
      '$partSnippet, $partId, $partStatistics',
      maxResults: channelIds.length,
      id: channelIds.join(','),
    );

    for (final item in res.items) {
      final channel = ChannelModel(
        id: item.id,
        description: item.snippet.description,
        profileColor: item.brandingSettings.channel.profileColor,
        subscriberCount: int.parse(item.statistics.subscriberCount),
        thumbnails: item.snippet.thumbnails,
        title: item.brandingSettings.channel.title,
        unsubscribedTrailer: item.brandingSettings.channel.unsubscribedTrailer,
      );
      log.v(channel.toJson());
      yield channel;
    }
  }

  Stream<ChannelModel> findFeaturedChannels(String channelId) async* {}

  Future<Map<String, dynamic>> _getVideoDetails(String videoId) async {
    final res = await _youtube.videos.list(
      '$partContentDetails, $partStatistics',
      id: videoId,
      maxResults: 1,
    );
    final video = res.items.first;
    return {
      'duration': fromISO8601(video.contentDetails.duration),
      'like': int.parse(video.statistics.likeCount),
      'dislike': int.parse(video.statistics.dislikeCount),
      'view': int.parse(video.statistics.viewCount),
    };
  }

  Future<Map<String, dynamic>> _getPlaylistDetails(String playlistId) async {
    final res = await _youtube.playlists.list(
      '$partContentDetails',
      id: playlistId,
      maxResults: 1,
    );

    final playlist = res.items.first;
    return {'videoCount': playlist.contentDetails.itemCount};
  }

  void dispose() {
    client.close();
  }
}
