// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaylistModel _$PlaylistModelFromJson(Map<String, dynamic> json) {
  return PlaylistModel(
    title: json['title'] as String,
    creator: json['creator'] as String,
    videoCount: json['videoCount'] as int,
    viewCount: json['viewCount'] as int,
    lastUpdated: json['lastUpdated'] == null
        ? null
        : DateTime.parse(json['lastUpdated'] as String),
    videos: (json['videos'] as List)
        ?.map((e) =>
            e == null ? null : VideoModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PlaylistModelToJson(PlaylistModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'creator': instance.creator,
      'videoCount': instance.videoCount,
      'viewCount': instance.viewCount,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
      'videos': instance.videos,
    };
