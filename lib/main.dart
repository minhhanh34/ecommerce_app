import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/repository/user_repository.dart';
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
import 'repository/cart_repository.dart';
import 'repository/favorite_repository.dart';
import 'repository/product_repository.dart';
import 'screen/home_page.dart';
import 'screen/sign_in_page.dart';
import 'services/banner_service.dart';
import 'services/cart_service.dart';
import 'services/product_service.dart';
import 'services/sign_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  final spref = await SharedPreferences.getInstance();
  String? uid = spref.getString('uid');

  runApp(EcommerceApp(uid: uid));
}

class EcommerceApp extends StatelessWidget {
  const EcommerceApp({Key? key, this.uid}) : super(key: key);
  final String? uid;

  @override
  Widget build(BuildContext context) {
    final SignService service = SignServiceIml(repository: UserRepository());
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => HomeCubit(
            bannerService:
                BannerServiceIml(database: FirebaseFirestore.instance),
            productService: ProductServiceIml(
              productRepo: ProductRepository(),
              favoriteRepo: FavoriteRepository(),
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
