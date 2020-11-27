import 'package:googleapis/youtube/v3.dart';
import 'package:json_annotation/json_annotation.dart';

part 'channel_model.g.dart';

@JsonSerializable()
class ChannelModel {
  final String id;
  final String title;
  final String description;
  final int subscriberCount;
  final ThumbnailDetails thumbnails;
  final String profileColor;
  final String unsubscribedTrailer;

  @JsonKey(ignore: true)
  List<String> featuredChannelIds;

  ChannelModel({
    this.id,
    this.title,
    this.description,
    this.subscriberCount,
    this.thumbnails,
    this.profileColor,
    this.unsubscribedTrailer,
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) =>
      _$ChannelModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChannelModelToJson(this);
}
