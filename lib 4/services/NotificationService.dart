import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Notification.dart';
import '../models/Moto.dart';


class NotificationService {
  final CollectionReference<Map<String, dynamic>> notifRef =
      FirebaseFirestore.instance.collection('notifications');
      

  /// ✅ Envoyer une notification
  Future<void> sendNotification(NotificationItem notif) async {
    try {
      await notifRef.doc(notif.id).set(notif.toMap());
    } catch (e) {
      print("Erreur sendNotification: $e");
    }
  }

  /// ✅ Récupérer les notifications d’un utilisateur
  Future<List<NotificationItem>> getUserNotifications(String userId) async {
    final snapshot =
        await notifRef.where('userId', isEqualTo: userId).get();

    return snapshot.docs
        .map((doc) => NotificationItem.fromMap(doc.data() ?? {}, doc.id))
        .toList();
  }

  /// ✅ Stream temps réel des notifications d’un utilisateur
  Stream<List<NotificationItem>> getUserNotificationsStream(String userId) {
    return notifRef
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationItem.fromMap(doc.data() ?? {}, doc.id))
            .toList());
  }

  /// ✅ Marquer une notification comme lue
  Future<void> markAsRead(String notifId) async {
    try {
      await notifRef.doc(notifId).update({'lu': true});
    } catch (e) {
      print("Erreur markAsRead: $e");
    }
  }

  /// ✅ Supprimer une notification
  Future<void> deleteNotification(String id) async {
    try {
      await notifRef.doc(id).delete();
    } catch (e) {
      print("Erreur deleteNotification: $e");
    }
  }
}
