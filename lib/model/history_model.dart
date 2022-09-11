import 'package:json_annotation/json_annotation.dart';

part 'history_model.g.dart';

@JsonSerializable()
class HistoryModel {
  String uid;
  Map<String, dynamic>? history;
  HistoryModel({required this.uid, this.history});

  factory HistoryModel.fromJson(Map<String, dynamic> json) =>
      _$HistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryModelToJson(this);
}
