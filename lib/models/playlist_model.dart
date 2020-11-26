import 'package:json_annotation/json_annotation.dart';

import 'video_model.dart';

part 'playlist_model.g.dart';

@JsonSerializable()
class PlaylistModel {
  final String title;
  final String creator;
  final int videoCount;
  final int viewCount;
  final DateTime lastUpdated;
  final List<VideoModel> videos;

  PlaylistModel({this.title, this.creator, this.videoCount, this.viewCount, this.lastUpdated, this.videos,});

  factory PlaylistModel.fromJson(Map<String,dynamic> json) => _$PlaylistModelFromJson(json);
  Map<String,dynamic> toJson() => _$PlaylistModelToJson(this);
}
