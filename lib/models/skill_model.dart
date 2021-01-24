import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'package:SingularSight/generated/skill_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SkillModel {
  final String name;
  final String keyword;
  final String icon;
  Uint8List _data;

  SkillModel({
    @required this.name,
    @required this.keyword,
    this.icon,
  })  : assert(name != null),
        assert(keyword != null);

  Uint8List get data {
    if (icon == null) return null;
    if (_data == null) {
      final uri = UriData.parse(icon);
      _data = uri.contentAsBytes();
    }
    return _data;
  }

  factory SkillModel.fromJson(Map<String, dynamic> json) =>
      _$SkillModelFromJson(json);
  Map<String, dynamic> toJson() => _$SkillModelToJson(this);
}
