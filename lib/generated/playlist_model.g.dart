// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../models/playlist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaylistModel _$PlaylistModelFromJson(Map<String, dynamic> json) {
  return PlaylistModel(
    id: json['id'] as String,
    title: json['title'] as String,
    videoCount: json['videoCount'] as int,
    thumbnails: json['thumbnails'] == null
        ? null
        : ThumbnailDetails.fromJson(json['thumbnails'] as Map<String, dynamic>),
    channel: json['channel'] == null
        ? null
        : ChannelModel.fromJson(json['channel'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PlaylistModelToJson(PlaylistModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'videoCount': instance.videoCount,
      'thumbnails': instance.thumbnails,
      'channel': instance.channel.toJson(),
    };
