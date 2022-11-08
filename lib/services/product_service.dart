import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/repository/repository_interface.dart';

abstract class ProductService {
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel> addProduct(ProductModel product);
}

class ProductServiceIml implements ProductService {
  ProductServiceIml(this.repository);

  Repository<ProductModel> repository;

  @override
  Future<List<ProductModel>> getAllProducts() async {
    return await repository.list();
  }

  @override
  Future<ProductModel> addProduct(ProductModel product) async {
    return await repository.create(product);
  }
}
