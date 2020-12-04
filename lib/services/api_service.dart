import 'package:SingularSight/models/channel_model.dart';
import '../utilities/string_utils.dart';
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

  Future<ApiResult<PlaylistModel>> getPlaylistsOfChannel(
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
    return ApiResult(
      nextToken: res.nextPageToken,
      prevToken: res.prevPageToken,
      items: result,
    );
  }

  /// Find all features channels stored in firebase firestore,
  /// then get details from [YoutubeApi]
  Future<ApiResult<ChannelModel>> getFeaturedChannels() async {
    final query = await FirebaseFirestore.instance.collection('channels').get();
    final ids = query.docs.map((e) => e.id).toList();
    final res = await _youtube.channels.list(
      '$partSnippet, $partBrandingSettings, $partId, $partStatistics',
      maxResults: ids.length,
      id: ids.join(','),
    );
    return ApiResult(
      nextToken: res.nextPageToken,
      prevToken: res.prevPageToken,
      items: res.items.map((e) => ChannelModel.fromChannel(e)).toList(),
    );
  }

  Future<ApiResult<ChannelModel>> getChannels(List<String> ids,
      {int n = 10}) async {
    final res = await _youtube.channels.list(
      '$partSnippet, $partBrandingSettings, $partId, $partStatistics',
      maxResults: ids.length,
      id: ids.join(','),
    );
    return ApiResult(
        nextToken: res.nextPageToken,
        prevToken: res.prevPageToken,
        items: res.items.map((e) => ChannelModel.fromChannel(e)).toList());
  }

  Future<ApiResult<PlaylistModel>> searchPlaylists(
    String q, {
    int n = 10,
    String order = orderViewCount,
    String nextToken,
  }) async {
    final res = await _youtube.search.list(
      partId,
      q: q,
      pageToken: nextToken,
      maxResults: n,
      type: typePlaylist,
      regionCode: regionVN,
    );

    final channels =
        res.items.map((e) => getChannel(e.snippet.channelId)).toList();
    final playlists =
        res.items.map((e) => getPlaylist(e.id.playlistId)).toList();

    final items = [];
    for (var i = 0; i < playlists.length; ++i) {
      final playlist = await playlists[i];
      playlist.channel = await channels[i];
      items.add(playlist);
    }
    return ApiResult(
      nextToken: res.nextPageToken,
      prevToken: res.prevPageToken,
      items: items,
    );
  }

  Future<ChannelModel> getChannel(String channelId) async {
    final res = await _youtube.channels.list(
      '$partSnippet, $partId, $partStatistics',
      maxResults: 1,
      id: channelId,
    );

    final item = res.items.first;
    final channel = ChannelModel.fromChannel(item);
    return channel;
  }

  Future<PlaylistModel> getPlaylist(String id) async {
    final res = await _youtube.playlists.list(
      '$partSnippet,$partContentDetails',
      id: id,
    );
    return PlaylistModel.fromPlaylist(res.items.first);
  }

  Future<VideoModel> getVideo(String videoId) async {
    final res = await _youtube.videos.list(
      '$partSnippet,$partStatistics,$partContentDetails',
      id: videoId,
      maxResults: 1,
    );
    final item = res.items.first;
    final video = VideoModel(
      channelId: item.snippet.channelId,
      channelTitle: item.snippet.channelTitle,
      description: item.snippet.description,
      title: item.snippet.title,
      id: videoId,
      thumbnails: item.snippet.thumbnails,
      dislikeCount: int.tryParse(item.statistics.dislikeCount ?? ''),
      likeCount: int.tryParse(item.statistics.likeCount ?? ''),
      duration: item.contentDetails.duration.toISO8601(),
      publishedAt: item.snippet.publishedAt,
      viewCount: int.tryParse(item.statistics.viewCount),
    );
    log.v(video);
    return video;
  }

  void dispose() {
    client.close();
  }
}

class ApiResult<T> {
  final String nextToken;
  final String prevToken;
  final List<T> items;

  ApiResult({
    this.nextToken,
    this.prevToken,
    this.items,
  });
}
