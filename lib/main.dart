import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/cubit/cart/cart_cubit.dart';
import 'package:ecommerce_app/cubit/forget_password.dart/forget_password_cubit.dart';
import 'package:ecommerce_app/cubit/home/home_cubit.dart';
import 'package:ecommerce_app/cubit/signin/signin_cubit.dart';
import 'package:ecommerce_app/cubit/signup/signup_cubit.dart';
import 'package:ecommerce_app/firebase_options.dart';
import 'package:ecommerce_app/repository/cart_repository.dart';
import 'package:ecommerce_app/repository/favorite_repository.dart';
import 'package:ecommerce_app/repository/product_repository.dart';

import 'package:ecommerce_app/screen/home_page.dart';
import 'package:ecommerce_app/screen/sign_in_page.dart';
import 'package:ecommerce_app/services/banner_service.dart';
import 'package:ecommerce_app/services/cart_service.dart';
import 'package:ecommerce_app/services/firebase_service.dart';
import 'package:ecommerce_app/services/sign_service.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  final spref = await SharedPreferences.getInstance();
  String? uid = spref.getString('uid');

  // final prodRepo = ProductRepository();
  // final products = await prodRepo.list();
  // products.forEach((element) => print(element.name));

  // print('++cart++');

  // final cartRepo = CartRepository();
  // final cart = await cartRepo.list();
  // cart.forEach((element) => print(element.uid));
  // print('++fav++');
  // final favRepo = FavoriteRepository();
  // final fav = await favRepo.list();
  // fav.forEach((element) => print(element.uid));

  runApp(EcommerceApp(uid: uid));
}

class EcommerceApp extends StatelessWidget {
  const EcommerceApp({Key? key, this.uid}) : super(key: key);
  final String? uid;

  @override
  Widget build(BuildContext context) {
    final SignService service = SignServiceIml();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => HomeCubit(
            bannerService:
                BannerServiceIml(database: FirebaseFirestore.instance),
            productService: ProductServiceIml(
              productRepo: ProductRepository(),
              favotireRepo: FavoriteRepository(),
            ),
          ),
        ),
        BlocProvider(create: (_) => SignInCubit(service: service)),
        BlocProvider(
          create: (context) => SignUpCubit(service: service),
        ),
        BlocProvider(
          create: (_) => CartCubit(
            service: CartServiceIml(repository: CartRepository()),
          ),
        ),
        BlocProvider(
          create: (context) => ForgetPasswordCubit(),
        )
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
