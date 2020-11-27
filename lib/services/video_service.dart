import 'package:SingularSight/models/channel_model.dart';
import 'package:SingularSight/models/playlist_model.dart';
import 'package:SingularSight/models/video_model.dart';
import 'package:SingularSight/utilities/string_utils.dart';
import 'package:SingularSight/utilities/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import '../utilities/keys.dart' as keys;

class VideoService {
  ///////////////////////////////////////////////////////////
  ///
  /// part paramaters
  ///
  ///////////////////////////////////////////////////////////
  static const String partSnippet = 'snippet';
  static const String partId = 'id';
  static const String partContentDetails = 'contentDetails';
  static const String partStatistics = 'statistics';
  static const String partBrandingSettings = 'brandingSettings';

  ///////////////////////////////////////////////////////////
  ///
  /// order paramaters
  ///
  ///////////////////////////////////////////////////////////
  static const String orderRelevance = 'relevance';
  static const String orderViewCount = 'viewCount';

  static const String typePlaylist = 'playlist';
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

    final stream = getVideoDetails(res.items.map((e) => e.id.videoId).toList());
    await for (final item in stream) yield item;
  }

  Stream<PlaylistModel> findPlaylistByChannel(String channelId) async* {
    final res = await _youtube.playlists.list(
      '$partId,$partSnippet,$partContentDetails',
      channelId: channelId,
    );
    for (final item in res.items) {
      final playlist = PlaylistModel(
        channelId: channelId,
        channelTitle: item.snippet.channelTitle,
        id: item.id,
        thumbnails: item.snippet.thumbnails,
        title: item.snippet.title,
        videoCount: item.contentDetails.itemCount,
      );
      log.v(playlist.toJson());
      yield playlist;
    }
  }

  /// search all playlists using the [query] for query term
  Stream<PlaylistModel> searchPlaylists(String query) async* {
    Future<int> getViewCount(String channelId, String playlistId) async {
      final res = await _youtube.playlists.list(
        partContentDetails,
        channelId: channelId,
        id: playlistId,
        maxResults: 1,
      );
      return res.items.first.contentDetails.itemCount;
    }

    final res = await _youtube.search.list(
      '$partSnippet,$partId,$partContentDetails',
      q: query,
      order: orderRelevance,
      type: typePlaylist,
      regionCode: regionVN,
    );

    for (final item in res.items) {
      int viewCount = await getViewCount(
        item.id.channelId,
        item.id.playlistId,
      );
      final playlist = PlaylistModel(
        channelId: item.id.channelId,
        channelTitle: item.snippet.channelTitle,
        id: item.id.playlistId,
        thumbnails: item.snippet.thumbnails,
        title: item.snippet.title,
        videoCount: viewCount,
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
      '$partSnippet, $partBrandingSettings, $partId, $partStatistics',
      maxResults: channelIds.length,
      id: channelIds.join(','),
    );

    for (final item in res.items) {
      final channel = ChannelModel(
        id: item.id,
        description: item.brandingSettings.channel.description,
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

  Stream<VideoModel> getVideoDetails(List<String> videoIds) async* {
    final res = await _youtube.videos.list(
      '$partSnippet, $partContentDetails, $partStatistics',
      id: videoIds.join(','),
      maxResults: videoIds.length,
    );
    for (final item in res.items) {
      final snippet = item.snippet;
      final model = VideoModel(
        channelId: snippet.channelId,
        channelTitle: htmlUnEscape.convert(snippet.channelTitle),
        description: htmlUnEscape.convert(snippet.description),
        id: item.id,
        publishedAt: snippet.publishedAt,
        thumbnails: snippet.thumbnails,
        title: htmlUnEscape.convert(snippet.title),
        duration: item.contentDetails.duration.toISO8601(),
        likeCount: int.parse(item.statistics.likeCount),
        dislikeCount: int.parse(item.statistics.dislikeCount),
        viewCount: int.parse(item.statistics.viewCount),
      );
      log.v(model.toJson());
      yield model;
    }
  }

  void dispose() {
    client.close();
  }
}
