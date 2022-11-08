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
  String? url;
  UserModel({
    required this.uid,
    required this.phone,
    required this.name,
    required this.address,
    required this.password,
    this.email,
    this.gender,
    this.birthDay,
    this.url,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? uid,
    String? phone,
    String? name,
    String? address,
    String? password,
    String? email,
    String? gender,
    DateTime? birthDay,
    String? url,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      address: address ?? this.address,
      password: password ?? this.password,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      birthDay: birthDay ?? this.birthDay,
      url: url ?? this.url,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.uid == uid &&
        other.phone == phone &&
        other.name == name &&
        other.address == address &&
        other.password == password &&
        other.email == email &&
        other.gender == gender &&
        other.birthDay == birthDay &&
        other.url == url;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        phone.hashCode ^
        name.hashCode ^
        address.hashCode ^
        password.hashCode ^
        email.hashCode ^
        gender.hashCode ^
        birthDay.hashCode ^
        url.hashCode;
  }
}
