import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/favorite_model.dart';
import 'repository_interface.dart';

class FavoriteRepository implements Repository<FavoriteModel> {
  final collection = FirebaseFirestore.instance.collection('favorite');

  @override
  Future<FavoriteModel> create(FavoriteModel item) async {
    await collection.add(item.toJson());
    return item;
  }

  @override
  Future<List<FavoriteModel>> list() async {
    final docs = await collection.get();
    return docs.docs.map((doc) {
      final data = doc.data();
      return FavoriteModel.fromJson(data);
    }).toList();
  }

  @override
  Future<FavoriteModel> getOne(String id) async {
    final doc = await collection.doc(id).get();
    return FavoriteModel.fromJson(doc.data()!);
  }

  @override
  Future<bool> update(String id, FavoriteModel item) async {
    await collection.doc(id).update(item.toJson()).catchError((err) => false);
    return true;
  }

  @override
  Future<bool> delete(String id) async {
    await collection.doc(id).delete().catchError((err) => false);
    return true;
  }

  @override
  Future<String> getDocumentID(String uid) async {
    final docs = await collection.get();
    return docs.docs.firstWhere((doc) => doc.data()['uid'] == uid).id;
  }
}
