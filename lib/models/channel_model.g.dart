// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelModel _$ChannelModelFromJson(Map<String, dynamic> json) {
  return ChannelModel(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    subscriberCount: json['subscriberCount'] as int,
    thumbnails: json['thumbnails'] == null
        ? null
        : ThumbnailDetails.fromJson(json['thumbnails'] as Map<String, dynamic>),
    profileColor: json['profileColor'] as String,
    unsubscribedTrailer: json['unsubscribedTrailer'] as String,
  );
}

Map<String, dynamic> _$ChannelModelToJson(ChannelModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'subscriberCount': instance.subscriberCount,
      'thumbnails': instance.thumbnails,
      'profileColor': instance.profileColor,
      'unsubscribedTrailer': instance.unsubscribedTrailer,
    };
