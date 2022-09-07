import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/favorite_model.dart';
import 'product_repository.dart';

class FavoriteRepository implements Repository<FavoriteModel> {
  final collection = 'favorite';

  @override
  Future<FavoriteModel> create(FavoriteModel item) async {
  
    await FirebaseFirestore.instance.collection(collection).add(item.toJson());
    return item;
  }

  @override
  Future<List<FavoriteModel>> list() async {
    final docs = await FirebaseFirestore.instance.collection(collection).get();
    return docs.docs.map((doc) {
      final data = doc.data();
      return FavoriteModel.fromJson(data);
    }).toList();
  }

  @override
  Future<FavoriteModel> getOne(String id) async {
    final docs = await FirebaseFirestore.instance.collection(collection).get();
    final doc = docs.docs.firstWhere((element) => element.data()['uid'] == id);
    final data = doc.data();
    return FavoriteModel.fromJson(data);
  }

  @override
  Future<bool> update(String id, FavoriteModel item) async {
    final docs = await FirebaseFirestore.instance.collection(collection).get();
    final docID =
        docs.docs.firstWhere((element) => element.data()['uid'] == item.uid).id;
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(docID)
        .update(item.toJson())
        .catchError((err) => false);
    return true;
  }

  @override
  Future<bool> delete(String id) async {
    final docs = await FirebaseFirestore.instance.collection(collection).get();
    final docID =
        docs.docs.firstWhere((element) => element.data()['uid'] == id).id;
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(docID)
        .delete()
        .catchError((err) => false);
    return true;
  }
}
