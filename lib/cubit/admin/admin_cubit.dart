import 'package:ecommerce_app/model/order_model.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/services/order_service.dart';
import 'package:ecommerce_app/services/product_service.dart';
import 'package:ecommerce_app/utils/libs.dart';

part 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit({
    required this.productService,
    required this.orderService,
  }) : super(AdminInitial());
  final ProductService productService;
  final OrderService orderService;

  List<OrderModel>? progressOrders;
  List<OrderModel>? finishedOrders;
  List<ProductModel>? products;

  Future<ProductModel> addProduct(ProductModel product) async {
    return await productService.addProduct(product);
  }

  Future<bool> updateProduct(ProductModel product) async {
    return await productService.updateProduct(product);
  }

  Future<void> getProgressOrders() async {
    emit(AdminLoading());

    progressOrders ??= await orderService.getProgressOrders();
    emit(AdminProgressOrders(progressOrders!));
  }

  Future<bool> updateOrder(OrderModel order) async {
    emit(AdminLoading());
    final result = await orderService.updateOrder(order);
    return result;
  }

  Future<void> refreshOrders(bool isFinish) async {
    emit(AdminLoading());
    if (isFinish) finishedOrders = null;
    getFinishedOrders();
  }

  Future<void> getFinishedOrders() async {
    emit(AdminLoading());
    finishedOrders ??= await orderService.getFinishedOrders();
    emit(AdminFinishedOrders(finishedOrders!));
  }

  Future<void> logout() async {
    final spref = await SharedPreferences.getInstance();
    await spref.remove('uid');
    finishedOrders = null;
    progressOrders = null;
    products = null;
    emit(AdminLogout());
  }

  Future<void> onAllProducts() async {
    emit(AdminLoading());
    products ??= await productService.getAllProducts();
    emit(AdminAllProducts(products!));
  }

  void onProductAddition() {
    emit(AdminProductAddition());
  }

  void onDetailProduct(ProductModel product) {
    emit(AdminDetailProduct(product));
  }

  Future<bool> deleteProduct(ProductModel product) async {
    return await productService.deleteProduct(product);
  }
}
