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

  int get progressOrdersCounts => progressOrders?.length ?? 0;
  int get finishedOrdersCounts => finishedOrders?.length ?? 0;
  int get productsCounts => products?.length ?? 0;
  int get revenue => finishedOrders!.fold<int>(
      0, (previousValue, order) => previousValue + order.totalPrice());

  Future<void> initialize() async {
    emit(AdminLoading());
    products = await productService.getAllProducts();
    progressOrders = await orderService.getProgressOrders();
    finishedOrders = await orderService.getFinishedOrders();
    emit(AdminLoaded(
      products: products!,
      progressOrders: progressOrders!,
      finishedOrders: finishedOrders!,
    ));
  }

  Future<ProductModel> addProduct(ProductModel product) async {
    return await productService.addProduct(product);
  }

  void onRevenue() async {
    emit(AdminRevenue(revenue, finishedOrders!));
    emit(AdminLoaded(
      products: products!,
      progressOrders: progressOrders!,
      finishedOrders: finishedOrders!,
    ));
  }

  Future<bool> updateProduct(ProductModel product) async {
    return await productService.updateProduct(product);
  }

  void onProgressOrders() async {
    emit(AdminProgressOrders(progressOrders!));
    emit(AdminLoaded(
      products: products!,
      progressOrders: progressOrders!,
      finishedOrders: finishedOrders!,
    ));
  }

  void onFinishedOrders() async {
    emit(AdminFinishedOrders(finishedOrders!));
    emit(AdminLoaded(
      products: products!,
      progressOrders: progressOrders!,
      finishedOrders: finishedOrders!,
    ));
  }

  Future<void> onRefresh() async {
    dispose();
    await initialize();
  }

  // Future<void> getProgressOrders() async {
  //   emit(AdminLoading());
  //   progressOrders ??= await orderService.getProgressOrders();
  //   emit(AdminProgressOrders(progressOrders!));
  // }

  Future<bool> updateOrder(OrderModel order) async {
    final result = await orderService.updateOrder(order);
    return result;
  }

  // Future<void> refreshOrders(bool isFinish) async {
  //   emit(AdminLoading());
  //   if (isFinish) finishedOrders = null;
  //   getFinishedOrders();
  // }

  Future<void> getFinishedOrders() async {
    emit(AdminLoading());
    finishedOrders ??= await orderService.getFinishedOrders();
    emit(AdminFinishedOrders(finishedOrders!));
  }

  Future<void> logout() async {
    emit(AdminLoading());
    final spref = await SharedPreferences.getInstance();
    await spref.remove('uid');
    dispose();
    emit(AdminLogout());
    // emit(AdminInitial());
  }

  void dispose() {
    finishedOrders = null;
    progressOrders = null;
    products = null;
  }

  Future<void> onAllProducts() async {
    emit(AdminLoading());
    products ??= await productService.getAllProducts();
    emit(AdminAllProducts(products!));
    emit(AdminLoaded(
      products: products!,
      progressOrders: progressOrders!,
      finishedOrders: finishedOrders!,
    ));
  }

  void onProductAddition() {
    emit(AdminProductAddition());
    emit(AdminLoaded(
      products: products!,
      progressOrders: progressOrders!,
      finishedOrders: finishedOrders!,
    ));
  }

  void onDetailProduct(ProductModel product) {
    emit(AdminDetailProduct(product));
    emit(AdminLoaded(
      products: products!,
      progressOrders: progressOrders!,
      finishedOrders: finishedOrders!,
    ));
  }

  Future<bool> deleteProduct(ProductModel product) async {
    return await productService.deleteProduct(product);
  }
}
