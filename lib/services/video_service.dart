import 'package:SingularSight/models/video.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:googleapis_auth/auth_browser.dart';

import '../utilities/keys.dart' as keys;

class VideoService {
  final youtube = YoutubeApi(clientViaApiKey(keys.youtube));
  VideoService();
  Stream<VideoModel> find(String channelId) async* {
    final res = await youtube.search.list(
      'contentDetails,statistics',
      channelId: 'UCdQHEqTxcFzjFCrq0o4V7dg',
    );

    for (final item in res.items) {
      final snippet = item.snippet;
      final video = await _detail(item.id.videoId);
      yield VideoModel(
        creator: snippet.channelTitle,
        description: snippet.description,
        id: item.id.videoId,
        publishedAt: snippet.publishedAt,
        thumbnails: snippet.thumbnails,
        title: snippet.title,
        duration: video['duration'],
        likeCount: video['like'],
        dislikeCount: video['dislike'],
        viewCount: video['view'],
      );
    }
  }

  Future<Map<String, dynamic>> _detail(String videoId) async {
    final res = await youtube.videos.list(
      'contentDetails,statistics',
      id: videoId,
    );
    final video = res.items.first;
    return {
      'duration': DateTime.parse(video.contentDetails.duration),
      'like': video.statistics.likeCount,
      'dislike': video.statistics.dislikeCount,
      'view': video.statistics.viewCount,
    };
  }
}
