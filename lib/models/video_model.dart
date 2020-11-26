import 'package:googleapis/youtube/v3.dart';
import 'package:json_annotation/json_annotation.dart';

part 'video_model.g.dart';

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

  factory VideoModel.fromJson(Map<String, dynamic> json) =>
      _$VideoModelFromJson(json);
  Map<String, dynamic> toJson() => _$VideoModelToJson(this);
}
