import 'package:cloud_firestore/cloud_firestore.dart';

class VerificationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'verifications';

  /// ✅ Sauvegarder une vérification et retourner l'ID généré
  Future<String?> saveVerification({
    required String agentId,
    required String plaque,
    required String resultat,
  }) async {
    try {
      final docRef = await _db.collection(_collection).add({
        'agentId': agentId,
        'plaque': plaque,
        'resultat': resultat,
        'date': Timestamp.now(),
      });
      return docRef.id;
    } catch (e) {
      print("Erreur saveVerification: $e");
      return null;
    }
  }

  /// ✅ Récupérer les vérifications d’un agent
  Future<List<Map<String, dynamic>>> getVerificationsByAgent(String agentId) async {
    final snapshot = await _db
        .collection(_collection)
        .where('agentId', isEqualTo: agentId)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  /// ✅ Stream temps réel des vérifications d’un agent
  Stream<List<Map<String, dynamic>>> getVerificationsStreamByAgent(String agentId) {
    return _db
        .collection(_collection)
        .where('agentId', isEqualTo: agentId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  /// ✅ Récupérer toutes les vérifications (Police/Admin)
  Future<List<Map<String, dynamic>>> getAllVerifications() async {
    final snapshot = await _db.collection(_collection).get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  /// ✅ Stream global (Police/Admin)
  Stream<List<Map<String, dynamic>>> getAllVerificationsStream() {
    return _db.collection(_collection).snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
