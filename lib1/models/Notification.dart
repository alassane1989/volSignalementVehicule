import 'package:cloud_firestore/cloud_firestore.dart';



class NotificationItem {
  final String id;
  final String userId;
  final String type;
  final String message;
  final bool lu;
  final DateTime dateHeure;

  NotificationItem({
    required this.id,
    required this.userId,
    required this.type,
    required this.message,
    required this.lu,
    required this.dateHeure,
  });

  factory NotificationItem.fromMap(Map<String, dynamic> map) => NotificationItem(
    id: map['id'],
    userId: map['userId'],
    type: map['type'],
    message: map['message'],
    lu: map['lu'],
    dateHeure: (map['dateHeure'] as Timestamp).toDate(),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'type': type,
    'message': message,
    'lu': lu,
    'dateHeure': Timestamp.fromDate(dateHeure),
  };
}
