// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
      uid: json['uid'] as String,
      date: (json['date'] as Timestamp).toDate(),
      order: (json['order'] as List)
          .map((e) => Map<String, dynamic>.from(e))
          .toList(),
      id: json['id'] as String,
      status: json['status'] as String? ?? 'Chờ xác nhận',
      address: json['address'] as String,
      recipient: json['recipient'] as String,
    );

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'order': instance.order,
      'date': instance.date,
      'status': instance.status,
      'address': instance.address,
      'recipient': instance.recipient,
    };
