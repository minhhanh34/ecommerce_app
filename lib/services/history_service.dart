import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/model/history_model.dart';
import 'package:ecommerce_app/model/product_model.dart';

import '../repository/repository_interface.dart';

abstract class HistoryService {
  Future<List<ProductModel>> getHistoryProducts(String uid);
  Future<bool> updateHistoryProducts(String uid, List<ProductModel> products);
}

class HistoryServiceIml implements HistoryService {
  Repository<HistoryModel> historyRepository;
  Repository<ProductModel> productRepository;
  HistoryServiceIml(this.historyRepository, this.productRepository);
  @override
  Future<List<ProductModel>> getHistoryProducts(String uid) async {
    final products = <ProductModel>[];
    final docSnap = await historyRepository.getQueryDocumentSnapshot(uid);
    final historyModel = await historyRepository.getOne(docSnap.id);
    final prodsRef = historyModel.history;
    for (var ref in prodsRef!.values) {
      final prodData =
          await (ref as DocumentReference<Map<String, dynamic>>).get();
      final product = ProductModel.fromJson(prodData.data()!);
      products.add(product);
    }
    return products;
  }

  @override
  Future<bool> updateHistoryProducts(
    String uid,
    List<ProductModel> products,
  ) async {
    final map = <String, DocumentReference>{};
    for (int i = 0; i < products.length; i++) {
      final docQuery =
          await productRepository.getQueryDocumentSnapshot(products[i].name);
      map.addAll({'product${i + 1}': docQuery.reference});
    }
    final favoriteModel = HistoryModel(uid: uid, history: map);
    final cartQuery = await historyRepository.getQueryDocumentSnapshot(uid);
    return await historyRepository.update(cartQuery.id, favoriteModel);
  }
}
