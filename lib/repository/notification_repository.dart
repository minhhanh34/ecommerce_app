import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/model/notification.dart';
import 'package:ecommerce_app/repository/repository_interface.dart';
import 'package:ecommerce_app/utils/libs.dart';

class NotificationRepository implements Repository<NotificationItem> {
  final userCollection = FirebaseFirestore.instance.collection('user');

  Future<CollectionReference> getNotificationReference() async {
    final spref = await SharedPreferences.getInstance();
    final uid = spref.getString('uid');
    final querySnapshot =
        await userCollection.where('uid', isEqualTo: uid).get();
    return querySnapshot.docs.first.reference.collection('notification');
  }

  @override
  Future<NotificationItem> create(NotificationItem item) async {
    final notificationsRef = await getNotificationReference();
    final json = item.toJson();
    final doc = await notificationsRef.add(json);
    json['id'] = doc.id;
    json['time'] = Timestamp.now();
    return NotificationItem.fromJson(json);
  }

  @override
  Future<bool> delete(String id) async {
    final ref = await getNotificationReference();
    await ref.doc(id).delete().catchError((_) => false);
    return true;
  }

  @override
  Future<NotificationItem> getOne(String id) async {
    final ref = await getNotificationReference();
    final snapshot = await ref.doc(id).get();
    final json = snapshot.data() as Map<String, dynamic>;
    json['id'] = snapshot.id;
    return NotificationItem.fromJson(json);
  }

  @override
  Future<QueryDocumentSnapshot<Object?>> getQueryDocumentSnapshot(
      String key) async {
    throw UnimplementedError();
  }

  @override
  Future<List<NotificationItem>> list() async {
    final ref = await getNotificationReference();
    final docs = await ref.orderBy('time', descending: true).get();
    return docs.docs.map((doc) {
      final json = doc.data() as Map<String, dynamic>;
      json['id'] = doc.id;
      return NotificationItem.fromJson(json);
    }).toList();
  }

  @override
  Future<bool> update(String id, NotificationItem item) async {
    final ref = await getNotificationReference();
    await ref.doc(id).update(item.toJson()).catchError((_) => false);
    return true;
  }
}
