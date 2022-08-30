import 'package:json_annotation/json_annotation.dart';
part 'product_detail_model.g.dart';

@JsonSerializable()
class ProductDetailModel {
  String? screenSize;
  String? resolution;
  String? tradeMark;
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

  ProductDetailModel({
    this.screenSize,
    this.resolution,
    this.tradeMark,
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

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDetailModelToJson(this);
}
