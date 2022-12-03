import 'package:ecommerce_app/model/notification.dart';
import 'package:ecommerce_app/repository/notification_repository.dart';

class NotificationService {
  final NotificationRepository repository;

  NotificationService({required this.repository});

  Future<NotificationItem> addNotification(NotificationItem item) async {
    return await repository.create(item);
  }

  Future<List<NotificationItem>> getNotification() async {
    return await repository.list();
  }

  Future<bool> updateNotification(String id, NotificationItem item) async {
    return await repository.update(id, item);
  }
}
