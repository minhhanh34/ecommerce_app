import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/model/favorite_model.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/repository/repository_interface.dart';

abstract class FavoriteService {
  Future<List<ProductModel>> getFavoriteProducts(String uid);
  Future<bool> updateFavoriteProducts(
      String uid, List<ProductModel> favoriteModel);
}

class FavoriteServiceIml implements FavoriteService {
  Repository<FavoriteModel> favoriteRepository;
  Repository<ProductModel> productRepository;
  FavoriteServiceIml(this.favoriteRepository, this.productRepository);

  @override
  Future<List<ProductModel>> getFavoriteProducts(String uid) async {
    final products = <ProductModel>[];
    final docSnap = await favoriteRepository.getQueryDocumentSnapshot(uid);
    final favoriteModel = await favoriteRepository.getOne(docSnap.id);
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
    List<ProductModel> products,
  ) async {
    final map = <String, DocumentReference>{};
    for (int i = 0; i < products.length; i++) {
      final docQuery =
          await productRepository.getQueryDocumentSnapshot(products[i].name);
      map.addAll({'product${i + 1}': docQuery.reference});
    }
    final favoriteModel = FavoriteModel(uid: uid, favorite: map);
    final cartQuery = await favoriteRepository.getQueryDocumentSnapshot(uid);
    return await favoriteRepository.update(cartQuery.id, favoriteModel);
  }
}
