import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/services/firebase_service.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('service test', () async {
    final service = ProductServiceIml(database: FirebaseFirestore.instance);
    final prods = await service.getAllProducts();
    for (var prod in prods) {
      print(prod);
    }
  });
}
 