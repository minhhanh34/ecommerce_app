import 'package:ecommerce_app/repository/cart_repository.dart';
import 'package:ecommerce_app/repository/favorite_repository.dart';
import 'package:ecommerce_app/repository/product_repository.dart';
import 'package:ecommerce_app/repository/user_repository.dart';
import 'package:ecommerce_app/services/cart_service.dart';
import 'package:ecommerce_app/services/home_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cubit/cart/cart_cubit.dart';
import 'cubit/forget_password.dart/forget_password_cubit.dart';
import 'cubit/home/home_cubit.dart';
import 'cubit/signin/signin_cubit.dart';
import 'cubit/signup/signup_cubit.dart';
import 'firebase_options.dart';
import 'repository/history_repository.dart';
import 'repository/order_repository.dart';
import 'screen/home_page.dart';
import 'screen/sign_in_page.dart';
import 'services/sign_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  final spref = await SharedPreferences.getInstance();
  String? uid = spref.getString('uid');

  // final cartService = CartServiceIml(CartRepository(), ProductRepository());
  // final products = <ProductModel>[];
  // products.addAll([
  //   ProductModel(name: 'Iphone 13', imageURL: {}, price: 100),
  //   ProductModel(name: 'Oppo Reno 7z', imageURL: {}, price: 100),
  //   ProductModel(name: 'Samsung S22 Ultra', imageURL: {}, price: 100),
  // ]);
  // cartService.update(
  //   'a181ccdd18', products,
  // );

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

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeCubit(homeService: HomeServiceIml())),
        BlocProvider(create: (_) => SignInCubit(service: service)),
        BlocProvider(create: (_) => SignUpCubit(service: service)),
        BlocProvider(
          create: (_) => CartCubit(
              service: CartServiceIml(CartRepository(), ProductRepository())),
        ),
        BlocProvider(create: (_) => ForgetPasswordCubit())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: uid == null ? const SignInPage() : const HomePage(),
      ),
    );
  }
}
