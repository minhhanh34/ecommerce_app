import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/model/banner_model.dart';
import 'package:ecommerce_app/services/home_service.dart';

abstract class BannerService extends Service {
  Future<BannerModel> getAllBanners();
}

class BannerServiceIml implements BannerService {
  BannerServiceIml();
  final database = FirebaseFirestore.instance;

  @override
  Future<BannerModel> getAllBanners() async {
    const banner = 'banner';
    final DocumentSnapshot<Map<String, dynamic>> results =
        await database.collection(banner).doc(banner).get();
    final urls = results.data()!.values.map((val) => val as String).toList();
    return BannerModel.fromUrls(urls);
  }
}
