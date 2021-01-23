import 'package:googleapis/youtube/v3.dart';
import 'package:json_annotation/json_annotation.dart';

part '../generated/channel_model.g.dart';

@JsonSerializable()
class ChannelModel {
  final String id;
  final String title;
  final String description;
  final int subscriberCount;
  final ThumbnailDetails thumbnails;
  final String profileColor;

  @JsonKey(ignore: true)
  List<String> featuredChannelIds;

  @JsonKey(ignore: true)
  List<ChannelModel> featuredChannels;

  ChannelModel({
    this.id,
    this.title,
    this.description,
    this.subscriberCount,
    this.thumbnails,
    this.profileColor,
  });

  factory ChannelModel.fromChannel(Channel item) {
    return ChannelModel(
      id: item.id,
      description: item.snippet.description,
      profileColor: item.brandingSettings.channel.profileColor,
      subscriberCount: int.tryParse(item.statistics.subscriberCount ?? ''),
      thumbnails: item.snippet.thumbnails,
      title: item.brandingSettings.channel.title,
    );
  }

  factory ChannelModel.fromJson(Map<String, dynamic> json) =>
      _$ChannelModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChannelModelToJson(this);
}
