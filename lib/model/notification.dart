import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

class NotificationItem extends Equatable {
  final String? id;
  final String? title;
  final String? message;
  final bool? seen;
  final DateTime? time;
  const NotificationItem({
    this.id,
    this.title,
    this.message,
    this.seen,
    this.time,
  });

  @override
  List<Object?> get props => [title, message, seen];

  @override
  bool get stringify => false;

  NotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    bool? seen,
    DateTime? time,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      seen: seen ?? this.seen,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'message': message,
      'seen': seen,
      'time': Timestamp.fromDate(time ?? DateTime.now()),
    };
  }

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      seen: json['seen'],
      time: (json['time'] as Timestamp).toDate(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationItem &&
        other.id == id &&
        other.title == title &&
        other.message == message &&
        other.seen == seen &&
        const DeepCollectionEquality().equals(other.time, time);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        message.hashCode ^
        seen.hashCode ^
        time.hashCode;
  }
}
