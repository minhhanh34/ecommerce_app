import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/model/order_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'history_model.g.dart';

@JsonSerializable()
class HistoryModel {
  String uid;
  List<DocumentReference<Map<String, dynamic>>> historyRef;
  List<OrderModel> history;
  HistoryModel({
    required this.uid,
    required this.historyRef,
  }) : history = [];

  factory HistoryModel.fromJson(Map<String, dynamic> json) =>
      _$HistoryModelFromJson(json)..build();

  Map<String, dynamic> toJson() => _$HistoryModelToJson(this);

  void build() async {
    for (var ref in historyRef) {
      final orderSnap = await ref.get();
      history.add(OrderModel.fromJson(orderSnap.data()!));
    }
  }
}
