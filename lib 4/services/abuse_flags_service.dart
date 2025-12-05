import 'package:cloud_firestore/cloud_firestore.dart';

class AbuseFlagsService {
  final _db = FirebaseFirestore.instance;

  /// ✅ Signaler un abus (citoyens uniquement)
  Future<void> flagReport(String reportId, String userId, String reason) async {
    final doc = _db.collection('abuse_flags').doc();
    await doc.set({
      'id': doc.id,
      'targetType': 'report',
      'targetId': reportId,
      'userId': userId,
      'reason': reason,
      'createdAt': Timestamp.now(),
      'status': 'open', // "open" ou "reviewed"
    });
  }

  /// ✅ Signaler un abus sur un commentaire
  Future<void> flagComment(String commentId, String userId, String reason) async {
    final doc = _db.collection('abuse_flags').doc();
    await doc.set({
      'id': doc.id,
      'targetType': 'comment',
      'targetId': commentId,
      'userId': userId,
      'reason': reason,
      'createdAt': Timestamp.now(),
      'status': 'open',
    });
  }

  /// ✅ Stream des abus pour modération (admin/police)
  Stream<List<Map<String, dynamic>>> abuseStream() {
    return _db
        .collection('abuse_flags')
        .where('status', isEqualTo: 'open')
        .snapshots()
        .map((s) => s.docs.map((d) => d.data()).toList());
  }
}
