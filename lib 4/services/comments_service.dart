import 'package:cloud_firestore/cloud_firestore.dart';

class CommentsService {
  final _db = FirebaseFirestore.instance;

  /// ✅ Ajouter un commentaire
  Future<void> addComment(String reportId, String userId, String text) async {
    final docRef = _db.collection("reports").doc(reportId);

    // Ajouter le commentaire dans la sous-collection
    await docRef.collection("comments").add({
      "userId": userId,
      "text": text.trim(),
      "createdAt": Timestamp.now(),
      "status": "visible", // peut être "flagged" si abus
    });

    // Incrémenter le compteur
    await docRef.update({
      "commentsCount": FieldValue.increment(1),
    });
  }

  /// ✅ Stream des commentaires visibles
  Stream<List<Map<String, dynamic>>> commentsStream(String reportId) {
    return _db
        .collection("reports")
        .doc(reportId)
        .collection("comments")
        .where("status", isEqualTo: "visible")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => d.data()).toList());
  }

  /// ✅ Supprimer un commentaire (admin/modération)
  Future<void> deleteComment(String reportId, String commentId) async {
    final docRef = _db.collection("reports").doc(reportId);

    // Supprimer le commentaire
    await docRef.collection("comments").doc(commentId).delete();

    // Décrémenter le compteur
    await docRef.update({
      "commentsCount": FieldValue.increment(-1),
    });
  }
}
