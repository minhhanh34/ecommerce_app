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
    )
      ..screenSize = json['screenSize'] as String?
      ..resolution = json['resolution'] as String?
      ..brand = json['brand'] as String?
      ..batteryCapacity = json['batteryCapacity'] as String?
      ..fontCamera = json['fontCamera'] as String?
      ..rearCamera = json['rearCamera'] as String?
      ..gpu = json['gpu'] as String?
      ..cpu = json['cpu'] as String?
      ..cpuSpeed = json['cpuSpeed'] as String?
      ..size = json['size'] as String?
      ..displayType = json['displayType'] as String?
      ..model = json['model'] as String?
      ..sims = json['sims'] as String?
      ..batteryType = json['batteryType'] as String?
      ..weight = json['weight'] as String?
      ..ram = json['ram'] as String?
      ..rom = json['rom'] as String?
      ..wifi = json['wifi'] as String?
      ..colorOption = ((json['colorOption'] as List?)
          ?.map((color) => color)
          .cast<String>()
          .toList())
      ..memoryOption = (json['memoryOption'] as List?)
          ?.map((memory) => memory['memory'])
          .cast<String>()
          .toList();

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'imageURL': instance.imageURL,
      'price': instance.price,
      'grade': instance.grade,
      'sold': instance.sold,
      'screenSize': instance.screenSize,
      'resolution': instance.resolution,
      'brand': instance.brand,
      'batteryCapacity': instance.batteryCapacity,
      'fontCamera': instance.fontCamera,
      'rearCamera': instance.rearCamera,
      'gpu': instance.gpu,
      'cpu': instance.cpu,
      'cpuSpeed': instance.cpuSpeed,
      'size': instance.size,
      'displayType': instance.displayType,
      'model': instance.model,
      'sims': instance.sims,
      'batteryType': instance.batteryType,
      'weight': instance.weight,
      'ram': instance.ram,
      'rom': instance.rom,
      'wifi': instance.wifi,
    };
