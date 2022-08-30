import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  final String name;
  final Map<String, dynamic> imageUrls;
  final int price;
  final int grade;
  final int sold;
  final bool isFavorite;
  ProductModel({
    required this.name,
    required this.imageUrls,
    required this.price,
    this.grade = 0,
    this.sold = 0,
    this.isFavorite = false,
  });
  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
