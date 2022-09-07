import 'package:cached_network_image/cached_network_image.dart';
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
  });
  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json)..buildImage();

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  void buildImage() {
    images.clear();
    for (var url in imageURL.entries) {
      final image = CachedNetworkImage(
        imageUrl: url.value,
        placeholder: (context, url) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(12),
            ),
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.width * 0.3,
            child: const Icon(Icons.image),
          );
        },
      );
      images.addAll(
        {url.key: image},
      );
    }
  }
}
