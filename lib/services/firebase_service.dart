import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/model/favorite_model.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/repository/product_repository.dart';

abstract class Service {}

abstract class ProductService extends Service {
  Future<List<ProductModel>?> getAllProducts();
  Future<ProductModel?> getProduct({required String prodID});
  Future<List<ProductModel>> getFavorite({required String uid});
}

class ProductServiceIml implements ProductService {
  const ProductServiceIml(
      {required this.productRepo, required this.favotireRepo});

  final Repository<ProductModel> productRepo;
  final Repository<FavoriteModel> favotireRepo;

  @override
  Future<List<ProductModel>?> getAllProducts() async {
    return await productRepo.list();
  }

  @override
  Future<ProductModel?> getProduct({required String prodID}) async {
    return await productRepo.getOne(prodID);
  }

  @override
  Future<List<ProductModel>> getFavorite({required String uid}) async {
    final products = <ProductModel>[];
    final favorite = await favotireRepo.getOne(uid);
    final prodsRef = favorite.favorite;
    for (var ref in prodsRef.values) {
      final prodData = await (ref as DocumentReference<Map<String, dynamic>>).get();
      final product =
          ProductModel.fromJson(prodData.data()!);
      products.add(product);
    }
    return products;
  }
}
