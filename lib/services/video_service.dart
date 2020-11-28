import 'package:SingularSight/models/channel_model.dart';
import 'package:SingularSight/models/playlist_model.dart';
import 'package:SingularSight/models/video_model.dart';
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
  static const String orderDate = 'date';

  static const String typePlaylist = 'playlist';
  static const String regionVN = 'vn';

  final http.Client client;
  YoutubeApi _youtube;
  VideoService([String apiKey = keys.youtube])
      : client = clientViaApiKey(keys.youtube) {
    _youtube = YoutubeApi(client);
  }

  Stream<VideoModel> findVideosOfPlaylist(String playlistId) async* {}

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
  Stream<PlaylistModel> searchPlaylists(
    String q, {
    int pageSize = 40,
    int pageOffset = 0,
    String order = orderDate,
  }) async* {
    // get all skills in firestore
    final snapshot = await FirebaseFirestore.instance
        .collection('searching')
        .doc('qlz4pSG7qHJq8xRu9uWJ')
        .get();
    final skills = await snapshot.get('skills').cast<String>();

    var nextPageToken = '';
    while (pageSize > 0 && nextPageToken != null) {
      final res = await _youtube.search.list(
        partId,
        q: skills.join('|'),
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
      final channel = ChannelModel.fromChannel(item);
      log.v(channel.toJson());
      yield channel;
    }
  }

  Stream<ChannelModel> findFeaturedChannels(String channelId) async* {}

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

  void dispose() {
    client.close();
  }
}
