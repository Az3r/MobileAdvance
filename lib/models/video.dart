import 'package:googleapis/youtube/v3.dart';

class VideoModel {
  final String id;
  final ThumbnailDetails thumbnails;
  final DateTime duration;
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
}
