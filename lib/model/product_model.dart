import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  String name;
  Map<String, dynamic> imageURL;
  int price;
  int grade;
  int sold;
  List<Map<String, dynamic>>? colorOption;
  List<Map<String, dynamic>>? memoryOption;
  String? screenSize;
  String? resolution;
  String? brand;
  String? batteryCapacity;
  String? fontCamera;
  String? rearCamera;
  String? gpu;
  String? cpu;
  String? cpuSpeed;
  String? size;
  String? displayType;
  String? model;
  String? sims;
  String? batteryType;
  String? weight;
  String? ram;
  String? rom;
  String? wifi;
  final images = <String, CachedNetworkImage>{};
  ProductModel({
    required this.name,
    required this.imageURL,
    required this.price,
    this.grade = 0,
    this.sold = 0,
    this.colorOption,
    this.memoryOption,
    this.screenSize,
    this.resolution,
    this.brand,
    this.batteryCapacity,
    this.fontCamera,
    this.rearCamera,
    this.gpu,
    this.cpu,
    this.cpuSpeed,
    this.size,
    this.displayType,
    this.model,
    this.sims,
    this.batteryType,
    this.weight,
    this.ram,
    this.rom,
    this.wifi,
  });
  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json)..buildImage();

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  void buildImage() {
    images.clear();
    for (var url in imageURL.entries) {
      final image = CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: url.value,
        placeholder: (context, url) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(12),
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: const Icon(Icons.image),
          );
        },
      );
      images.addAll(
        {url.key: image},
      );
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductModel &&
        other.name == name &&
        mapEquals(other.imageURL, imageURL) &&
        other.price == price &&
        other.grade == grade &&
        other.sold == sold &&
        listEquals(other.colorOption, colorOption) &&
        listEquals(other.memoryOption, memoryOption) &&
        other.screenSize == screenSize &&
        other.resolution == resolution &&
        other.brand == brand &&
        other.batteryCapacity == batteryCapacity &&
        other.fontCamera == fontCamera &&
        other.rearCamera == rearCamera &&
        other.gpu == gpu &&
        other.cpu == cpu &&
        other.cpuSpeed == cpuSpeed &&
        other.size == size &&
        other.displayType == displayType &&
        other.model == model &&
        other.sims == sims &&
        other.batteryType == batteryType &&
        other.weight == weight &&
        other.ram == ram &&
        other.rom == rom &&
        other.wifi == wifi;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        imageURL.hashCode ^
        price.hashCode ^
        grade.hashCode ^
        sold.hashCode ^
        colorOption.hashCode ^
        memoryOption.hashCode ^
        screenSize.hashCode ^
        resolution.hashCode ^
        brand.hashCode ^
        batteryCapacity.hashCode ^
        fontCamera.hashCode ^
        rearCamera.hashCode ^
        gpu.hashCode ^
        cpu.hashCode ^
        cpuSpeed.hashCode ^
        size.hashCode ^
        displayType.hashCode ^
        model.hashCode ^
        sims.hashCode ^
        batteryType.hashCode ^
        weight.hashCode ^
        ram.hashCode ^
        rom.hashCode ^
        wifi.hashCode;
  }

  ProductModel copyWith({
    String? name,
    Map<String, dynamic>? imageURL,
    int? price,
    int? grade,
    int? sold,
    List<Map<String,dynamic>>? colorOption,
    List<Map<String,dynamic>>? memoryOption,
    String? screenSize,
    String? resolution,
    String? brand,
    String? batteryCapacity,
    String? fontCamera,
    String? rearCamera,
    String? gpu,
    String? cpu,
    String? cpuSpeed,
    String? size,
    String? displayType,
    String? model,
    String? sims,
    String? batteryType,
    String? weight,
    String? ram,
    String? rom,
    String? wifi,
  }) {
    return ProductModel(
      name: name ?? this.name,
      imageURL: imageURL ?? this.imageURL,
      price: price ?? this.price,
      grade: grade ?? this.grade,
      sold: sold ?? this.sold,
      colorOption: colorOption ?? this.colorOption,
      memoryOption: memoryOption ?? this.memoryOption,
      screenSize: screenSize ?? this.screenSize,
      resolution: resolution ?? this.resolution,
      brand: brand ?? this.brand,
      batteryCapacity: batteryCapacity ?? this.batteryCapacity,
      fontCamera: fontCamera ?? this.fontCamera,
      rearCamera: rearCamera ?? this.rearCamera,
      gpu: gpu ?? this.gpu,
      cpu: cpu ?? this.cpu,
      cpuSpeed: cpuSpeed ?? this.cpuSpeed,
      size: size ?? this.size,
      displayType: displayType ?? this.displayType,
      model: model ?? this.model,
      sims: sims ?? this.sims,
      batteryType: batteryType ?? this.batteryType,
      weight: weight ?? this.weight,
      ram: ram ?? this.ram,
      rom: rom ?? this.rom,
      wifi: wifi ?? this.wifi,
    );
  }
}
