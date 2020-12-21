import 'package:googleapis/youtube/v3.dart';
import 'package:json_annotation/json_annotation.dart';

import '../utilities/string_utils.dart';
import 'playlist_model.dart';

part '../generated/video_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class VideoModel {
  final String id;
  final String title;
  final String description;
  final Duration duration;
  final String channelId;
  final ThumbnailDetails thumbnails;

  /// store in UTC time
  final DateTime publishedAt;
  final int viewCount;
  final String channelTitle;
  final int likeCount;
  final int dislikeCount;

  VideoModel({
    this.id,
    this.channelId,
    this.likeCount,
    this.dislikeCount,
    this.viewCount,
    this.channelTitle,
    this.thumbnails,
    this.duration,
    this.title,
    this.description,
    this.publishedAt,
  });

  factory VideoModel.fromVideo(Video item) {
    return VideoModel(
      channelId: item.snippet.channelId,
      channelTitle: item.snippet.channelTitle,
      description: item.snippet.description,
      title: item.snippet.title,
      id: item.id,
      thumbnails: item.snippet.thumbnails,
      dislikeCount: int.tryParse(item.statistics.dislikeCount ?? ''),
      likeCount: int.tryParse(item.statistics.likeCount ?? ''),
      duration: item.contentDetails.duration.toISO8601(),
      publishedAt: item.snippet.publishedAt,
      viewCount: int.tryParse(item.statistics.viewCount),
    );
  }

  factory VideoModel.fromJson(Map<String, dynamic> json) =>
      _$VideoModelFromJson(json);
  Map<String, dynamic> toJson() => _$VideoModelToJson(this);
}
