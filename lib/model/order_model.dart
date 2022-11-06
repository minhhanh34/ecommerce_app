import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:ecommerce_app/model/product_model.dart';

part 'order_model.g.dart';

@JsonSerializable()
class OrderModel {
  String id;
  String uid;
  DateTime date;
  String status;
  List<Map<String, dynamic>> order;
  String address;
  OrderModel({
    required this.uid,
    required this.order,
    required this.date,
    required this.id,
    required this.status,
    required this.address,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  Future<void> build() async {
    for (var element in order) {
      final doc =
          await (element['ref'] as DocumentReference<Map<String, dynamic>>)
              .get();
      element.addAll({
        'product': ProductModel.fromJson(doc.data()!),
      });
    }
  }

  OrderModel copyWith({
    String? id,
    String? uid,
    DateTime? date,
    String? status,
    List<Map<String, dynamic>>? order,
    String? address,
  }) {
    return OrderModel(
      address: address ?? this.address,
      id: id ?? this.id,
      uid: uid ?? this.uid,
      date: date ?? this.date,
      status: status ?? this.status,
      order: order ?? this.order,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderModel &&
        other.id == id &&
        other.uid == uid &&
        other.date == date &&
        other.status == status &&
        listEquals(other.order, order);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uid.hashCode ^
        date.hashCode ^
        status.hashCode ^
        order.hashCode ^
        address.hashCode;
  }
}
