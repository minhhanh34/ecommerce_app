import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/model/favorite_model.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/repository/repository_interface.dart';

abstract class FavoriteService {
  Future<List<ProductModel>> getFavoriteProducts(String uid);
  Future<bool> updateFavoriteProducts(String uid, FavoriteModel favoriteModel);
}

class FavoriteServiceIml implements FavoriteService {
  Repository<FavoriteModel> repository;
  FavoriteServiceIml(this.repository);

  @override
  Future<List<ProductModel>> getFavoriteProducts(String uid) async {
    final products = <ProductModel>[];
    final docID = await repository.getDocumentID(uid);
    final favoriteModel = await repository.getOne(docID);
    final prodsRef = favoriteModel.favorite;
    for (var ref in prodsRef!.values) {
      final prodData =
          await (ref as DocumentReference<Map<String, dynamic>>).get();
      final product = ProductModel.fromJson(prodData.data()!);
      products.add(product);
    }
    return products;
  }

  @override
  Future<bool> updateFavoriteProducts(
    String uid,
    FavoriteModel favoriteModel,
  ) async {
    return await repository.update(uid, favoriteModel);
  }
}
