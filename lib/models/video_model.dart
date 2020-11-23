import 'package:googleapis/youtube/v3.dart';
import 'package:json_annotation/json_annotation.dart';

part 'video_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class VideoModel {
  final String id;
  final ThumbnailDetails thumbnails;
  final Duration duration;
  final String title;
  final String description;
  final DateTime publishedAt;
  final int viewCount;
  final String creator;
  final int likeCount;
  final int dislikeCount;

  VideoModel({
    this.id,
    this.likeCount,
    this.dislikeCount,
    this.viewCount,
    this.creator,
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
