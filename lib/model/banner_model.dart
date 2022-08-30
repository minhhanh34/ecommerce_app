import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BannerModel {
  final List<CachedNetworkImage> banners;
  BannerModel({required this.banners});
  factory BannerModel.fromUrls(List<String> urls) => BannerModel(
        banners: [
          for (String url in urls)
            CachedNetworkImage(
                imageUrl: url,
                placeholder: (context, url) {
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      height: 120,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                      ),
                      child: const Icon(Icons.image),
                    ),
                  );
                }),
        ],
      );
}
