import 'package:ecommerce_app/admin/screens/add_product_screen.dart';
import 'package:ecommerce_app/services/favorite_service.dart';
import 'package:ecommerce_app/services/order_service.dart';
import 'package:ecommerce_app/services/user_service.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import './utils/libs.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final spref = await SharedPreferences.getInstance();
  String? uid = spref.getString('uid');
  // final service = OrderServiceIml(OrderRepository(), ProductRepository());
  // final orderRepository = OrderRepository();
  // // final docs = await service.getUserOrder('fec245c1f9');
  // final orderModel = OrderModel(
  //   uid: 'fec245c1f9',
  //   order: <Map<String, dynamic>>[
  //     {
  //       'color': '0xFFFF0000',
  //       'memory': '4GB - 64GB',
  //       'quantity': 1,
  //       'ref': FirebaseFirestore.instance
  //           .collection('products')
  //           .doc('xiaomi12pro'),
  //     }
  //   ],
  //   date: DateTime.now(),
  //   id: '',
  //   status: 'Chờ xác nhận',
  // );
  // // await orderRepository.create(orderModel);
  // print(uid!);
  // final service = HistoryServiceIml(HistoryRepository(), ProductRepository());
  // final historyOrders = await service.getHistoryOrders(uid!);
  runApp(EcommerceApp(uid: uid));
}

class EcommerceApp extends StatelessWidget {
  EcommerceApp({Key? key, this.uid}) : super(key: key);
  final String? uid;

  final SignService service = SignServiceIml(
    userRepo: UserRepository(),
    cartRepo: CartRepository(),
    favoriteRepo: FavoriteRepository(),
    historyRepo: HistoryRepository(),
    orderRepo: OrderRepository(),
  );

  final cartCubit = CartCubit(
    service: CartServiceIml(CartRepository(), ProductRepository()),
  );

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => HomeCubit(
            orderService: OrderServiceIml(
              OrderRepository(),
              ProductRepository(),
            ),
            homeService: HomeServiceIml(),
            cartCubit: cartCubit,
            favoriteService: FavoriteServiceIml(
              FavoriteRepository(),
              ProductRepository(),
            ),
            userService: UserServiceIml(UserRepository()),
          ),
        ),
        BlocProvider(create: (_) => SignInCubit(service: service)),
        BlocProvider(create: (_) => SignUpCubit(service: service)),
        BlocProvider(create: (_) => cartCubit),
        BlocProvider(create: (_) => ForgetPasswordCubit())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AddProductScreen(),
      ),
    );
  }
}


// home
// uid == null ? const SignInPage() : const HomePage()