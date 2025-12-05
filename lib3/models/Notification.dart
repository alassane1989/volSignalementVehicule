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

  /// ✅ Factory avec docId en paramètre
  factory NotificationItem.fromMap(Map<String, dynamic> map, String docId) {
    return NotificationItem(
      id: map['id'] ?? docId,
      userId: map['userId'] ?? '',
      type: map['type'] ?? '',
      message: map['message'] ?? '',
      lu: map['lu'] ?? false,
      dateHeure: (map['dateHeure'] is Timestamp)
          ? (map['dateHeure'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'message': message,
      'lu': lu,
      'dateHeure': Timestamp.fromDate(dateHeure),
    };
  }
}