import 'package:json_annotation/json_annotation.dart';
part 'cart_model.g.dart';

@JsonSerializable()
class CartModel {
  String uid;
  Map<String, dynamic> cart;
  CartModel({required this.uid, required this.cart});

  factory CartModel.fromJson(Map<String, dynamic> json) =>
      _$CartModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartModelToJson(this);
}
