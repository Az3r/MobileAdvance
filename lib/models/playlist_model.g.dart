// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaylistModel _$PlaylistModelFromJson(Map<String, dynamic> json) {
  return PlaylistModel(
    id: json['id'] as String,
    title: json['title'] as String,
    channelId: json['channelId'] as String,
    channelTitle: json['channelTitle'] as String,
    videoCount: json['videoCount'] as int,
    thumbnails: json['thumbnails'] == null
        ? null
        : ThumbnailDetails.fromJson(json['thumbnails'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PlaylistModelToJson(PlaylistModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'channelId': instance.channelId,
      'channelTitle': instance.channelTitle,
      'videoCount': instance.videoCount,
      'thumbnails': instance.thumbnails,
    };
