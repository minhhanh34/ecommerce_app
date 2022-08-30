// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      name: json['name'] as String,
      imageURL: json['imageURL'] as Map<String, dynamic>,
      price: json['price'] as int,
      grade: json['grade'] as int? ?? 0,
      sold: json['sold'] as int? ?? 0,
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'imageURL': instance.imageURL,
      'price': instance.price,
      'grade': instance.grade,
      'sold': instance.sold,
    };
