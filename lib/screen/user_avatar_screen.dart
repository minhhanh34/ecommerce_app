import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/model/user_model.dart';
import 'package:flutter/material.dart';

class UserAvatarScreen extends StatelessWidget {
  const UserAvatarScreen(this.user, {super.key});
  final UserModel user;

  final maleAvatarUrl =
      'https://firebasestorage.googleapis.com/v0/b/ecommerce-app-f4334.appspot.com/o/avatars%2Fmale-avatar.png?alt=media&token=2ab2c77e-4254-40e0-82b2-49132c1420ca';
  final femaleAvatarUrl =
      'https://firebasestorage.googleapis.com/v0/b/ecommerce-app-f4334.appspot.com/o/avatars%2Ffemale-avatar.png?alt=media&token=8888de2c-5332-41c9-91ec-dbfd455adf6d';

  String getAvatarUrl(UserModel user) {
    if (user.url != null) return user.url!;
    if (user.gender?.toLowerCase() == 'nam') return maleAvatarUrl;
    return femaleAvatarUrl;
  }

  @override
  Widget build(BuildContext context) {
    builder(context) {
      final size = MediaQuery.of(context).size;
      if (user.url == null) {
        return Container(
          color: Colors.white,
          child: CachedNetworkImage(
            imageUrl: getAvatarUrl(user),
          ),
        );
      }
      return AspectRatio(
        aspectRatio: 1.0,
        child: Hero(
          tag: user.name,
          child: CachedNetworkImage(
            width: size.width,
            imageUrl: user.url!,
          ),
        ),
      );
    }

    void dragHandle(dragDetail) {
      Navigator.of(context).pop();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onVerticalDragEnd: dragHandle,
        child: SafeArea(
          child: Center(
            child: Builder(builder: builder),
          ),
        ),
      ),
    );
  }
}
