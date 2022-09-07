import 'package:json_annotation/json_annotation.dart';
part 'favorite_model.g.dart';

@JsonSerializable()
class FavoriteModel {
  String uid;
  Map<String, dynamic> favorite;
  FavoriteModel({required this.uid, required this.favorite});

  factory FavoriteModel.fromJson(Map<String, dynamic> json) =>
      _$FavoriteModelFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteModelToJson(this);
}
