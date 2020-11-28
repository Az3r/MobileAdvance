import 'package:googleapis/youtube/v3.dart';
import 'package:json_annotation/json_annotation.dart';

import 'video_model.dart';

part '../generated/playlist_model.g.dart';

@JsonSerializable()
class PlaylistModel {
  final String id;
  final String title;
  final String channelId;
  final String channelTitle;
  final int videoCount;
  final ThumbnailDetails thumbnails;
  final ThumbnailDetails channelThumbnails;
  final int channelSubscribers;

  PlaylistModel({
    this.id,
    this.title,
    this.channelId,
    this.channelTitle,
    this.videoCount,
    this.thumbnails,
    this.channelThumbnails,
    this.channelSubscribers,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) =>
      _$PlaylistModelFromJson(json);
  Map<String, dynamic> toJson() => _$PlaylistModelToJson(this);
}
