import 'package:ecommerce_app/cubit/admin/admin_cubit.dart';
import 'package:ecommerce_app/cubit/notification/notification_cubit.dart';
import 'package:ecommerce_app/repository/notification_repository.dart';
import 'package:ecommerce_app/services/favorite_service.dart';
import 'package:ecommerce_app/services/notification_service.dart';
import 'package:ecommerce_app/services/order_service.dart';
import 'package:ecommerce_app/services/product_service.dart';
import 'package:ecommerce_app/services/user_service.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import './utils/libs.dart';
import 'admin/screens/admin_screen.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final spref = await SharedPreferences.getInstance();
  String? uid = spref.getString('uid');
  runApp(EcommerceApp(uid: uid));
}

class EcommerceApp extends StatelessWidget {
  const EcommerceApp({Key? key, this.uid}) : super(key: key);
  final String? uid;

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    final productRepository = ProductRepository();
    final orderRepository = OrderRepository();
    final userRepository = UserRepository();
    final cartRepository = CartRepository();
    final favoriteRepository = FavoriteRepository();
    final historyRepository = HistoryRepository();
    final cartService = CartServiceIml(cartRepository, productRepository);
    final productService = ProductServiceIml(productRepository);
    final orderService = OrderServiceIml(orderRepository, productRepository);
    final homeService = HomeServiceIml();
    final userService = UserServiceIml(userRepository);
    final notificationRepository = NotificationRepository();
    final notificationService =
        NotificationService(repository: notificationRepository);
    final favoriteService = FavoriteServiceIml(
      favoriteRepository,
      productRepository,
    );
    final service = SignServiceIml(
      userRepo: userRepository,
      cartRepo: cartRepository,
      favoriteRepo: favoriteRepository,
      historyRepo: historyRepository,
      orderRepo: orderRepository,
    );
    final cartCubit = CartCubit(service: cartService);
    final signInCubit = SignInCubit(service: service);
    final signUpCubit = SignUpCubit(service: service);
    final forgetPasswordCubit = ForgetPasswordCubit();
    final notificationCubit = NotificationCubit(notificationService);
    final adminCubit = AdminCubit(
      productService: productService,
      orderService: orderService,
    );
    final homeCubit = HomeCubit(
      homeService: homeService,
      favoriteService: favoriteService,
      cartCubit: cartCubit,
      orderService: orderService,
      userService: userService,
      notificationCubit: notificationCubit,
    );

    // notificationRepository.create(
    //   const NotificationItem(
    //     title: 'thong bao cua minh hanh',
    //     message: 'chi vui thoi',
    //     seen: false,
    //   ),
    // );
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => homeCubit),
        BlocProvider(create: (_) => signInCubit),
        BlocProvider(create: (_) => signUpCubit),
        BlocProvider(create: (_) => cartCubit),
        BlocProvider(create: (_) => forgetPasswordCubit),
        BlocProvider(create: (_) => adminCubit),
        BlocProvider(create: (_) => notificationCubit)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Builder(
          builder: (context) {
            if (uid == null) {
              return const SignInScreen();
            }
            if (uid == 'admin') {
              return const AdminScreen();
            }
            return const HomeScreen();
          },
        ),
      ),
    );
  }
}
