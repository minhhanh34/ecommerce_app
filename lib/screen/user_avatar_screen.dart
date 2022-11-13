import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/model/user_model.dart';
import 'package:flutter/material.dart';

import '../utils/consts.dart';

class UserAvatarScreen extends StatelessWidget {
  const UserAvatarScreen(this.user, {super.key});
  final UserModel user;

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
