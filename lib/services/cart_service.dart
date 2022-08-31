import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/model/cart_model.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/services/firebase_service.dart';

abstract class CartService extends Service {
  Future<CartModel> getCart({required String userId});
}

class CartServiceIml implements CartService {
  @override
  Future<CartModel> getCart({required String userId}) async {
    List<ProductModel> products = [];
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('cart').doc(userId).get();
    Map<String, dynamic> data = snapshot.data()!;
    for (DocumentReference<Map<String, dynamic>> docRef in data.values) {
      DocumentSnapshot<Map<String, dynamic>> doc = await docRef.get();
      Map<String, dynamic> json = doc.data()!;
      products.add(ProductModel.fromJson(json));
    }
    return CartModel(products: products);
  }
}
