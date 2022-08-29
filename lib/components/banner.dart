// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/material.dart';

class HeaderBanner extends StatefulWidget {
  const HeaderBanner({Key? key}) : super(key: key);

  @override
  State<HeaderBanner> createState() => _HeaderBannerState();
}

class _HeaderBannerState extends State<HeaderBanner> {
  late Timer _timer;
  final _controller = PageController();
  final bannerContent = const <Widget>[
    Icon(
      Icons.circle,
      size: 10,
      color: Colors.white,
    ),
    Icon(
      Icons.circle,
      size: 10,
      color: Colors.white,
    ),
    Icon(
      Icons.circle,
      size: 10,
      color: Colors.white,
    ),
  ];

  Widget buildDotNav() {
    return Row(
      children: bannerContent,
    );
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (timer) {
        if (_controller.page!.toInt() == bannerContent.length - 1) {
          _controller.jumpTo(0);
        }
        _controller.nextPage(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
        );
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
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey.shade100,
          gradient: LinearGradient(
            colors: [
              Colors.orange.shade300,
              Colors.green.shade300,
            ],
          ),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: PageView(
                controller: _controller,
                children: const [
                  FlutterLogo(
                    size: 100,
                  ),
                  FlutterLogo(
                    size: 100,
                  ),
                  FlutterLogo(
                    size: 100,
                  ),
                ],
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width * 0.5 - 23,
              bottom: 0,
              child: buildDotNav(),
            ),
          ],
        ),
      ),
    );
  }
}
