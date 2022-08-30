import 'package:json_annotation/json_annotation.dart';
part 'cart_model.g.dart';

@JsonSerializable()
class CartModel {
  final String imageURL;
  final String name;
  final int price;
  final int saleOff;
  final int quantity;
  final bool isFavorite;
  final String color;
  final int rom;
  final int ram;
  CartModel({
    required this.imageURL,
    required this.name,
    required this.price,
    this.saleOff = 0,
    this.quantity = 1,
    this.isFavorite = false,
    required this.color,
    required this.rom,
    required this.ram,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) =>
      _$CartModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartModelToJson(this);
}
