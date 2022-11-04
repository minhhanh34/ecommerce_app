import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String uid;
  final String phone;
  final String name;
  final String address;
  final String password;
  String? email;
  String? gender;
  DateTime? birthDay;
  UserModel({
    required this.uid,
    required this.phone,
    required this.name,
    required this.address,
    required this.password,
    this.email,
    this.gender,
    this.birthDay,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
