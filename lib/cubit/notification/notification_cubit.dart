import 'package:ecommerce_app/model/notification.dart';
import 'package:ecommerce_app/services/notification_service.dart';
import 'package:ecommerce_app/utils/libs.dart';

import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit(this.service) : super(NotificationInitial());

  final NotificationService service;
  List<NotificationItem>? notifications;

  Future<void> getNotification() async {
    notifications = await service.getNotification();
  }

  Future<void> onNotification() async {
    // if (notifications != null) {
    //   emit(AllNotification(notifications!));
    //   return;
    // }
    emit(NotificationLoading());
    notifications = await service.getNotification();

    emit(AllNotification(notifications!));
  }

  Future<void> refresh() async {
    notifications = null;
    onNotification();
  }

  Future<bool> update(String id, NotificationItem item) async {
    final result = await service.updateNotification(id, item);
    if (!result) return false;
    for (var i = 0; i < notifications!.length; i++) {
      if (notifications![i].id == id) {
        notifications![i] = item;
        break;
      }
    }
    emit(AllNotification(notifications!));
    return true;
  }

  void dispose() {
    notifications = null;
    emit(NotificationInitial());
  }
}
