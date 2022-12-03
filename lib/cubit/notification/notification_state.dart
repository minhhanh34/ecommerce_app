import 'package:ecommerce_app/model/notification.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class AllNotification extends NotificationState {
  final List<NotificationItem> notifications;
  AllNotification(this.notifications);
}

class NotificationLoading extends NotificationState {}
