// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package:SingularSight/models/skill_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SkillModel _$SkillModelFromJson(Map<String, dynamic> json) {
  return SkillModel(
    name: json['name'] as String,
    keyword: json['keyword'] as String,
    icon: json['icon'] as String,
  );
}

Map<String, dynamic> _$SkillModelToJson(SkillModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'keyword': instance.keyword,
      'icon': instance.icon,
    };
