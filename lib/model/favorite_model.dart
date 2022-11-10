import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'favorite_model.g.dart';

@JsonSerializable()
class FavoriteModel {
  String uid;
  Map<String, dynamic>? favorite;
  FavoriteModel({required this.uid, required this.favorite});

  factory FavoriteModel.fromJson(Map<String, dynamic> json) =>
      _$FavoriteModelFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteModelToJson(this);

  FavoriteModel copyWith({
    String? uid,
    Map<String, dynamic>? favorite,
  }) {
    return FavoriteModel(
      uid: uid ?? this.uid,
      favorite: favorite ?? this.favorite,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FavoriteModel &&
        other.uid == uid &&
        mapEquals(other.favorite, favorite);
  }

  @override
  int get hashCode => uid.hashCode ^ favorite.hashCode;
}
