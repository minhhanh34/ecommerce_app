import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ecommerce_app/model/product_model.dart';

class CartItem {
  String id;
  String uid;
  ProductModel? product;
  String color;
  String imageURL;
  String memory;
  int price;
  int quantity;
  DocumentReference ref;
  CartItem({
    this.product,
    required this.id,
    required this.uid,
    required this.color,
    required this.imageURL,
    required this.memory,
    required this.price,
    required this.quantity,
    required this.ref,
  });

  Future<void> build() async {
    final data = await (ref as DocumentReference<Map<String, dynamic>>).get();
    product = ProductModel.fromJson(data.data()!);
  }

  CartItem copyWith({
    ProductModel? product,
    String? color,
    String? imageURL,
    String? memory,
    int? price,
    int? quantity,
    DocumentReference? ref,
    String? uid,
    String? id,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      color: color ?? this.color,
      imageURL: imageURL ?? this.imageURL,
      memory: memory ?? this.memory,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      ref: ref ?? this.ref,
      uid: uid ?? this.uid,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CartItem &&
        other.product == product &&
        other.color == color &&
        other.imageURL == imageURL &&
        other.memory == memory &&
        other.price == price &&
        other.quantity == quantity &&
        other.ref == ref &&
        other.id == id &&
        other.uid == uid;
  }

  @override
  int get hashCode {
    return product.hashCode ^
        color.hashCode ^
        imageURL.hashCode ^
        memory.hashCode ^
        price.hashCode ^
        quantity.hashCode ^
        id.hashCode ^
        uid.hashCode ^
        ref.hashCode;
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      color: json['color'] as String,
      imageURL: json['imageURL'] as String,
      memory: json['memory'] as String,
      price: json['price'] as int,
      quantity: json['quantity'] as int,
      ref: json['ref'] as DocumentReference,
      uid: json['uid'] as String,
      id: json['id'] as String
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'color': color,
      'imageURL': imageURL,
      'memory': memory,
      'price': price,
      'quantity': quantity,
      'ref': ref,
      'uid': uid,
      'id': id,
    };
  }
}
