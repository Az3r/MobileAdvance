import 'dart:convert';

import 'package:SingularSight/models/video_model.dart';
import 'package:SingularSight/utilities/duration_utils.dart';
import 'package:SingularSight/utilities/globals.dart';
import 'package:flutter/foundation.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:googleapis_auth/auth_io.dart';

import '../utilities/keys.dart' as keys;

class VideoService {
  final client;
  YoutubeApi _youtube;
  VideoService([String apiKey = keys.youtube])
      : client = clientViaApiKey(keys.youtube) {
    _youtube = YoutubeApi(client);
  }
  Stream<VideoModel> find(String channelId) async* {
    final res = await _youtube.search.list(
      'snippet',
      channelId: 'UCdQHEqTxcFzjFCrq0o4V7dg',
    );

    for (final item in res.items) {
      final snippet = item.snippet;
      final video = await _detail(item.id.videoId);
      final model = VideoModel(
        creator: htmlUnEscape.convert(snippet.channelTitle),
        description: htmlUnEscape.convert(snippet.description),
        id: item.id.videoId,
        publishedAt: snippet.publishedAt,
        thumbnails: snippet.thumbnails,
        title: htmlUnEscape.convert(snippet.title),
        duration: video['duration'],
        likeCount: video['like'],
        dislikeCount: video['dislike'],
        viewCount: video['view'],
      );
      log.v(model.toJson());
      yield model;
    }
  }

  Future<Map<String, dynamic>> _detail(String videoId) async {
    final res = await _youtube.videos.list(
      'contentDetails,statistics',
      id: videoId,
    );
    final video = res.items.first;
    return {
      'duration': fromISO8601(video.contentDetails.duration),
      'like': int.parse(video.statistics.likeCount),
      'dislike': int.parse(video.statistics.dislikeCount),
      'view': int.parse(video.statistics.viewCount),
    };
  }

  void dispose() {
    client.close();
  }
}
