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

  Future<ApiResult<PlaylistModel>> findPlaylistByChannel_future(
      ChannelModel channel,
      {int n = 10}) async {
    final res = await _youtube.playlists.list(
      '$partId,$partSnippet,$partContentDetails',
      channelId: channel.id,
      maxResults: n,
    );
    final result = res.items
        .map((e) => PlaylistModel(
              channel: channel,
              id: e.id,
              thumbnails: e.snippet.thumbnails,
              title: e.snippet.title,
              videoCount: e.contentDetails.itemCount,
            ))
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

  Future<ApiResult<ChannelModel>> getChannelDetails(List<String> ids,
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

  Stream<PlaylistModel> findPlaylistByChannel(String channelId) async* {
    final res = await _youtube.playlists.list(
      '$partId,$partSnippet,$partContentDetails',
      channelId: channelId,
      maxResults: 50,
    );
    for (final item in res.items) {
      final playlist = PlaylistModel(
        channel: ChannelModel(
          title: item.snippet.channelTitle,
          id: item.snippet.channelId,
        ),
        id: item.id,
        thumbnails: item.snippet.thumbnails,
        title: item.snippet.title,
        videoCount: item.contentDetails.itemCount,
      );
      log.v(playlist.toJson());
      yield playlist;
    }
  }

  /// search all playlists using the [q] for query term
  /// [q] if null then get query from firestore
  Stream<PlaylistModel> searchPlaylists({
    String q,
    int pageSize = 40,
    int pageOffset = 0,
    String order = orderViewCount,
  }) async* {
    if (q == null) {
      // get all skills in firestore
      final snapshot = await FirebaseFirestore.instance
          .collection('searching')
          .doc('qlz4pSG7qHJq8xRu9uWJ')
          .get();
      final skills = await snapshot.get('skills').cast<String>();
      q = skills.join('|');
    }

    var nextPageToken = '';
    while (pageSize > 0 && nextPageToken != null) {
      final res = await _youtube.search.list(
        partId,
        q: q,
        pageToken: nextPageToken,
        maxResults: pageSize,
        order: order,
        type: typePlaylist,
        regionCode: regionVN,
      );
      nextPageToken = res.nextPageToken;

      final stream =
          getPlaylistDetails(res.items.map((e) => e.id.playlistId).toList());
      await for (final item in stream) yield item;

      pageSize -= res.items.length;
    }
  }

  /// Get all channels stored in cloud firestore
  Stream<ChannelModel> getAllChannels() async* {
    final query = await FirebaseFirestore.instance
        .collection('searching')
        .doc('qlz4pSG7qHJq8xRu9uWJ')
        .get();
    final ids = query.get('channels').cast<String>();
    await for (final channel in findChannels(ids)) yield channel;
  }

  Future<ChannelModel> findChannelById(String channelId) async {
    final res = await _youtube.channels.list(
      '$partSnippet, $partId, $partStatistics',
      maxResults: 1,
      id: channelId,
    );

    final item = res.items.first;
    final channel = ChannelModel.fromChannel(item);
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
      final channel = ChannelModel.fromChannel(item);
      log.v(channel.toJson());
      yield channel;
    }
  }

  Stream<PlaylistModel> getPlaylistDetails(List<String> playlistIds) async* {
    final res = await _youtube.playlists.list(
      '$partSnippet, $partContentDetails',
      id: playlistIds.join(','),
      maxResults: playlistIds.length,
    );
    for (final item in res.items) {
      final channel = await findChannels([item.snippet.channelId]).first;
      final playlist = PlaylistModel(
        channel: channel,
        id: item.id,
        title: item.snippet.title,
        thumbnails: item.snippet.thumbnails,
        videoCount: item.contentDetails.itemCount,
      );
      log.v(playlist.toJson());
      yield playlist;
    }
  }

  Stream<String> findVideoIdsByPlaylist(String playlistId) async* {
    final res = await _youtube.playlistItems.list(
      '$partSnippet',
      playlistId: playlistId,
      maxResults: 50,
    );

    for (final item in res.items) {
      final video = item.snippet.resourceId.videoId;
      yield video;
    }
  }

  Future<VideoModel> getVideoDetails(String videoId) async {
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
