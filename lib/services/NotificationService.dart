import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Notification.dart';

class NotificationService {
  final CollectionReference<Map<String, dynamic>> notifRef =
      FirebaseFirestore.instance.collection('notifications');

  Future<void> sendNotification(NotificationItem notif) async {
    await notifRef.doc(notif.id).set(notif.toMap());
  }

  Future<List<NotificationItem>> getUserNotifications(String userId) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await notifRef.where('userId', isEqualTo: userId).get();

    return snapshot.docs
        .map((doc) => NotificationItem.fromMap(doc.data()))
        .toList();
  }

  Future<void> markAsRead(String notifId) async {
    await notifRef.doc(notifId).update({'lu': true});
  }

  Future<void> deleteNotification(String id) async {
    await notifRef.doc(id).delete();
  }
}
