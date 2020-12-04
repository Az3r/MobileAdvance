import 'package:SingularSight/models/video_model.dart';
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
  final String channelId;

  @JsonKey(ignore: true)
  ChannelModel channel;

  @JsonKey(ignore: true)
  List<VideoModel> videos;

  PlaylistModel({
    this.channelId,
    this.id,
    this.title,
    this.thumbnails,
    this.videoCount,
  });

  factory PlaylistModel.fromPlaylist(Playlist item) {
    return PlaylistModel(
      id: item.id,
      channelId: item.snippet.channelId,
      thumbnails: item.snippet.thumbnails,
      title: item.snippet.title,
      videoCount: item.contentDetails.itemCount,
    );
  }

  factory PlaylistModel.fromJson(Map<String, dynamic> json) =>
      _$PlaylistModelFromJson(json);
  Map<String, dynamic> toJson() => _$PlaylistModelToJson(this);
}
