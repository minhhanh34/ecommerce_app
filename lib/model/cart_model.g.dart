// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartModel _$CartModelFromJson(Map<String, dynamic> json) => CartModel(
      imageURL: json['imageURL'] as String,
      name: json['name'] as String,
      price: json['price'] as int,
      saleOff: json['saleOff'] as int? ?? 0,
      quantity: json['quantity'] as int? ?? 1,
      isFavorite: json['isFavorite'] as bool? ?? false,
      color: json['color'] as String,
      rom: json['rom'] as int,
      ram: json['ram'] as int,
    );

Map<String, dynamic> _$CartModelToJson(CartModel instance) => <String, dynamic>{
      'imageURL': instance.imageURL,
      'name': instance.name,
      'price': instance.price,
      'saleOff': instance.saleOff,
      'quantity': instance.quantity,
      'isFavorite': instance.isFavorite,
      'color': instance.color,
      'rom': instance.rom,
      'ram': instance.ram,
    };
