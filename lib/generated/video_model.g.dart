// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../models/video_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoModel _$VideoModelFromJson(Map<String, dynamic> json) {
  return VideoModel(
    id: json['id'] as String,
    channelId: json['channel_id'] as String,
    likeCount: json['like_count'] as int,
    dislikeCount: json['dislike_count'] as int,
    viewCount: json['view_count'] as int,
    channelTitle: json['channel_title'] as String,
    thumbnails: json['thumbnails'] == null
        ? null
        : ThumbnailDetails.fromJson(json['thumbnails'] as Map<String, dynamic>),
    duration: json['duration'] == null
        ? null
        : Duration(microseconds: json['duration'] as int),
    title: json['title'] as String,
    description: json['description'] as String,
    publishedAt: json['published_at'] == null
        ? null
        : DateTime.parse(json['published_at'] as String),
  );
}

Map<String, dynamic> _$VideoModelToJson(VideoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'duration': instance.duration?.inMicroseconds,
      'channel_id': instance.channelId,
      'thumbnails': instance.thumbnails,
      'published_at': instance.publishedAt?.toIso8601String(),
      'view_count': instance.viewCount,
      'channel_title': instance.channelTitle,
      'like_count': instance.likeCount,
      'dislike_count': instance.dislikeCount,
    };
