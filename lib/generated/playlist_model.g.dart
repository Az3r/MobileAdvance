// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../models/playlist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaylistModel _$PlaylistModelFromJson(Map<String, dynamic> json) {
  return PlaylistModel(
    channelId: json['channelId'] as String,
    id: json['id'] as String,
    title: json['title'] as String,
    thumbnails: json['thumbnails'] == null
        ? null
        : ThumbnailDetails.fromJson(json['thumbnails'] as Map<String, dynamic>),
    videoCount: json['videoCount'] as int,
  );
}

Map<String, dynamic> _$PlaylistModelToJson(PlaylistModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'thumbnails': instance.thumbnails,
      'videoCount': instance.videoCount,
      'channelId': instance.channelId,
    };
