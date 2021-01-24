import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

part '../generated/skill_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SkillModel {
  final String name;
  final String keyword;

  SkillModel({
    @required this.name,
    @required this.keyword,
  })  : assert(name != null),
        assert(keyword != null);

  factory SkillModel.fromJson(Map<String, dynamic> json) =>
      _$SkillModelFromJson(json);
  Map<String, dynamic> toJson() => _$SkillModelToJson(this);
}
