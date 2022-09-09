import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/model/favorite_model.dart';
import 'package:ecommerce_app/model/product_model.dart';

import '../repository/repository_interface.dart';

abstract class Service {}

abstract class ProductService extends Service {
  Future<List<ProductModel>?> getAllProducts();
  Future<ProductModel> getProduct({required String prodID});
  Future<List<ProductModel>> getFavorite({required String uid});
  Future<ProductModel> addProduct(ProductModel product);
  Future<ProductModel> removeProduct(ProductModel product);
}

class ProductServiceIml implements ProductService {
  const ProductServiceIml(
      {required this.productRepo, required this.favoriteRepo});

  final Repository<ProductModel> productRepo;
  final Repository<FavoriteModel> favoriteRepo;

  @override
  Future<List<ProductModel>?> getAllProducts() async {
    return await productRepo.list();
  }

  @override
  Future<ProductModel> getProduct({required String prodID}) async {
    final docID = await productRepo.getDocumentID(prodID);
    return await productRepo.getOne(docID);
  }

  @override
  Future<List<ProductModel>> getFavorite({required String uid}) async {
    final products = <ProductModel>[];
    final favorites = await favoriteRepo.list();
    final favorite = favorites.firstWhere((favorite) => favorite.uid == uid);
    final prodsRef = favorite.favorite;
    for (var ref in prodsRef.values) {
      final prodData =
          await (ref as DocumentReference<Map<String, dynamic>>).get();
      final product = ProductModel.fromJson(prodData.data()!);
      products.add(product);
    }
    return products;
  }

  @override
  Future<ProductModel> addProduct(ProductModel product) async {
    // TODO: implement addProduct
    throw UnimplementedError();
  }

  @override
  Future<ProductModel> removeProduct(ProductModel product) async {
    // TODO: implement removeProduct
    throw UnimplementedError();
  }
}
