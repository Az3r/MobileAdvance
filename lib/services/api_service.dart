import 'package:SingularSight/models/channel_model.dart';
import 'package:SingularSight/models/playlist_model.dart';
import 'package:SingularSight/models/video_model.dart';
import 'package:SingularSight/utilities/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import '../utilities/keys.dart' as keys;

class ApiService {
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
  static const String orderDate = 'date';

  static const String typePlaylist = 'playlist';
  static const String regionVN = 'vn';

  final http.Client client;
  YoutubeApi _youtube;
  ApiService([String apiKey = keys.youtube])
      : client = clientViaApiKey(keys.youtube) {
    _youtube = YoutubeApi(client);
  }

  Future<ApiToken<PlaylistModel>> getPlaylistsOfChannel(
    ChannelModel channel, {
    int n = 10,
    String nextToken,
  }) async {
    final res = await _youtube.playlists.list(
      '$partId,$partSnippet,$partContentDetails',
      channelId: channel.id,
      maxResults: n,
      pageToken: nextToken,
    );
    final result = res.items
        .map((e) => PlaylistModel(
              id: e.id,
              thumbnails: e.snippet.thumbnails,
              title: e.snippet.title,
              videoCount: e.contentDetails.itemCount,
            )..channel = channel)
        .toList();
    return ApiToken(
      nextToken: res.nextPageToken,
      prevToken: res.prevPageToken,
      items: result,
    );
  }

  /// Find all features channels stored in firebase firestore,
  /// then get details from [YoutubeApi]
  Future<ApiToken<ChannelModel>> getFeaturedChannels() async {
    final query = await FirebaseFirestore.instance.collection('channels').get();
    final ids = query.docs.map((e) => e.id).toList();
    final res = await _youtube.channels.list(
      '$partSnippet, $partBrandingSettings, $partId, $partStatistics',
      maxResults: ids.length,
      id: ids.join(','),
    );
    return ApiToken(
      nextToken: res.nextPageToken,
      prevToken: res.prevPageToken,
      items: res.items.map((e) => ChannelModel.fromChannel(e)).toList(),
    );
  }

  Future<ApiToken<PlaylistModel>> searchPlaylists(
    String q, {
    int n = 10,
    String order = orderRelevance,
    String nextToken,
  }) async {
    final res = await _youtube.search.list(
      '$partId,$partSnippet',
      q: q,
      pageToken: nextToken,
      maxResults: n,
      type: typePlaylist,
      regionCode: regionVN,
    );

    final ids = res.items.map((item) => item.id.playlistId).toList();
    final items = await getPlaylists(ids, withChannel: true);

    return ApiToken<PlaylistModel>(
      nextToken: res.nextPageToken,
      prevToken: res.prevPageToken,
      items: items,
    );
  }

  /// Get playlists as well as its associated channel (optional).
  ///
  /// If [withChannel] is false, [PlaylistModel.channel] is null
  Future<List<PlaylistModel>> getPlaylists(List<String> ids,
      {bool withChannel = false}) async {
    final res = await _youtube.playlists.list(
      '$partSnippet,$partContentDetails',
      id: ids.join(','),
    );
    final results = [];
    for (final item in res.items) {
      final channel =
          withChannel ? await _getChannel(item.snippet.channelId) : null;
      final playlist = PlaylistModel.fromPlaylist(item)..channel = channel;
      results.add(playlist);
    }
    return results;
  }

  Future<ApiToken<VideoModel>> getVideosFromPlaylist(
    PlaylistModel playlist, {
    int n = 10,
    String nextToken,
  }) async {
    final res = await _youtube.playlistItems.list(
      partSnippet,
      $fields: 'items(snippet(resourceId))',
      playlistId: playlist.id,
      maxResults: n,
    );

    final videos =
        await _getVideos(res.items.map((e) => e.snippet.resourceId.videoId));

    return ApiToken(
      nextToken: res.nextPageToken,
      prevToken: res.prevPageToken,
      items: videos,
    );
  }

  Future<VideoModel> getFirstVideoOfPlaylist(PlaylistModel playlist) async {
    final res = await _youtube.playlistItems.list(
      partSnippet,
      $fields: 'items(snippet(resourceId))',
      playlistId: playlist.id,
      maxResults: 1,
    );
    return _getVideo(res.items.first.snippet.resourceId.videoId);
  }

  Future<ChannelModel> _getChannel(String channelId) async {
    final res = await _youtube.channels.list(
      '$partSnippet, $partId, $partStatistics, $partBrandingSettings',
      maxResults: 1,
      id: channelId,
    );

    final item = res.items.first;
    final channel = ChannelModel.fromChannel(item);
    return channel;
  }

  Future<VideoModel> _getVideo(String videoId) async {
    final res = await _youtube.videos.list(
      '$partSnippet,$partStatistics,$partContentDetails',
      id: videoId,
      maxResults: 1,
    );
    final item = res.items.first;
    final video = VideoModel.fromVideo(item);
    log.v(video);
    return video;
  }

  Future<List<VideoModel>> _getVideos(Iterable<String> ids) async {
    final res = await _youtube.videos.list(
      '$partSnippet,$partStatistics,$partContentDetails',
      id: ids.join(','),
      maxResults: ids.length,
    );
    return res.items.map((e) => VideoModel.fromVideo(e)).toList();
  }

  void dispose() {
    client.close();
  }
}

/// a token containing results for current call to api, as well as last call token and next call token
class ApiToken<T> {
  final String nextToken;
  final String prevToken;
  final List<T> items;

  ApiToken({
    this.nextToken,
    this.prevToken,
    this.items = const [],
  });
}
