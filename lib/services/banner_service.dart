import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/model/banner_model.dart';
import 'package:ecommerce_app/services/firebase_service.dart';

class BannerService extends Service {
  BannerService({required this.database});
  FirebaseFirestore database;
  Future<BannerModel> getBanners() async {
    const banner = 'banner';
    final DocumentSnapshot<Map<String, dynamic>> results =
        await database.collection(banner).doc(banner).get();
    final urls = results.data()!.values.map((val) => val as String).toList();
    return BannerModel.fromUrls(urls);
  }
}
