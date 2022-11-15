import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
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
  String recipient;
  OrderModel({
    required this.uid,
    required this.order,
    required this.date,
    required this.id,
    required this.status,
    required this.address,
    required this.recipient,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json)..build();

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
    String? recipient,
  }) {
    return OrderModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      date: date ?? this.date,
      status: status ?? this.status,
      order: order ?? this.order,
      address: address ?? this.address,
      recipient: recipient ?? this.recipient,
    );
  }

  int totalPrice() {
    int total = 0;
    for (var ord in order) {
      total += (ord['price'] as int) * (ord['quantity'] as int);
    }
    return total;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderModel &&
        other.id == id &&
        other.uid == uid &&
        other.date == date &&
        other.status == status &&
        other.recipient == recipient &&
        const DeepCollectionEquality.unordered().equals(other.order, order) &&
        other.address == address;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uid.hashCode ^
        date.hashCode ^
        status.hashCode ^
        order.hashCode ^
        recipient.hashCode ^
        address.hashCode;
  }
}
