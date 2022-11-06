// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
      uid: json['uid'] as String,
      date: (json['date'] as Timestamp).toDate(),
      order: (json['order'] as List).map((e) => Map<String,dynamic>.from(e)).toList(),
      id: json['id'] as String,
      status: json['status'],
      address: json['address'],
    );

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'order': instance.order,
      'date': DateTime.now(),
      'status': instance.status,
      'address': instance.address,
    };
