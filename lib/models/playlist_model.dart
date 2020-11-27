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

  List<VideoModel> _videos;
  @JsonKey(ignore: true)
  List<VideoModel> get videos {
    return _videos;
  }

  PlaylistModel({
    this.id,
    this.title,
    this.channelId,
    this.channelTitle,
    this.videoCount,
    this.thumbnails,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) =>
      _$PlaylistModelFromJson(json);
  Map<String, dynamic> toJson() => _$PlaylistModelToJson(this);
}
