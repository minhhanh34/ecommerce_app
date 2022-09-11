import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/model/history_model.dart';
import 'package:ecommerce_app/model/product_model.dart';

import '../repository/repository_interface.dart';

abstract class HistoryService {
  Future<List<ProductModel>> getHistoryProducts(String uid);
  Future<bool> updateHistoryProducts(String uid, HistoryModel historyModel);
}

class HistoryServiceIml implements HistoryService {
  Repository<HistoryModel> repository;
  HistoryServiceIml(this.repository);
  @override
  Future<List<ProductModel>> getHistoryProducts(String uid) async {
    final products = <ProductModel>[];
    final docID = await repository.getDocumentID(uid);
    final historyModel = await repository.getOne(docID);
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
    HistoryModel historyModel,
  ) async {
    return await repository.update(uid, historyModel);
  }
}
