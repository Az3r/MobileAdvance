import 'package:googleapis/youtube/v3.dart';
import 'package:json_annotation/json_annotation.dart';

import 'channel_model.dart';

part '../generated/playlist_model.g.dart';

@JsonSerializable()
class PlaylistModel {
  final String id;
  final String title;
  final ThumbnailDetails thumbnails;
  final int videoCount;
  final ChannelModel channel;

  PlaylistModel({
    this.id,
    this.title,
    this.thumbnails,
    this.videoCount,
    this.channel,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) =>
      _$PlaylistModelFromJson(json);
  Map<String, dynamic> toJson() => _$PlaylistModelToJson(this);
}
