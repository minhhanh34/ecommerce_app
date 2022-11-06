// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      uid: json['uid'] as String,
      phone: json['phone'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      password: json['password'] as String,
      email: json['email'] as String?,
      birthDay: (json['birthDay'] as Timestamp?)?.toDate(),
      gender: json['gender'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'uid': instance.uid,
      'phone': instance.phone,
      'name': instance.name,
      'address': instance.address,
      'password': instance.password,
      'email': instance.email,
      'birthDay': instance.birthDay,
      'gender': instance.gender,
    };
