import 'package:cloud_firestore/cloud_firestore.dart';

class LikesService {
  final _db = FirebaseFirestore.instance;

  /// ✅ Ajouter un like (un seul par utilisateur)
  Future<void> likeReport(String reportId, String userId) async {
    final ref = _db.collection('likes').doc('$reportId-$userId');
    await ref.set({
      'reportId': reportId,
      'userId': userId,
      'createdAt': Timestamp.now(),
    });

    // Optionnel : incrémenter un score de popularité
    await _db.collection('reports').doc(reportId).update({
      'publicScore': FieldValue.increment(1),
    });
  }

  /// ✅ Retirer un like
  Future<void> unlikeReport(String reportId, String userId) async {
    final ref = _db.collection('likes').doc('$reportId-$userId');
    await ref.delete();

    await _db.collection('reports').doc(reportId).update({
      'publicScore': FieldValue.increment(-1),
    });
  }

  /// ✅ Compter les likes en temps réel
  Stream<int> likeCount(String reportId) {
    return _db
        .collection('likes')
        .where('reportId', isEqualTo: reportId)
        .snapshots()
        .map((s) => s.docs.length);
  }
}
