// ignore_for_file: file_names

import 'dart:async';

import 'package:ecommerce_app/model/banner_model.dart';
import 'package:flutter/material.dart';

class HeaderBanner extends StatefulWidget {
  const HeaderBanner({Key? key, required this.model}) : super(key: key);
  final BannerModel model;

  @override
  State<HeaderBanner> createState() => _HeaderBannerState();
}

class _HeaderBannerState extends State<HeaderBanner> {
  late Timer _timer;
  final _controller = PageController();

  // Future<List<String>> getBanners() async {
  //   List<String> urls = [];
  //   ListResult results =
  //       await FirebaseStorage.instance.ref().child('banner').listAll();
  //   for (int i = 0; i < results.items.length; i++) {
  //     String url = await results.items[i].getDownloadURL();
  //     urls.add(url);
  //   }
  //   bannerCounts = results.items.length;
  //   return urls;
  // }

  int bannerCounts = 0;

  @override
  void initState() {
    super.initState();
    bannerCounts = widget.model.banners.length;
    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (timer) {
        _controller.nextPage(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
        );
        if (_controller.page!.round() == bannerCounts - 1) {
          _controller.animateToPage(
            0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
        left: 16,
        right: 16,
        bottom: 0,
      ),
      child: SizedBox(
        height: 120,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: PageView(
                controller: _controller,
                children: widget.model.banners,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
