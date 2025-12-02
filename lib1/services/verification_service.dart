import 'package:cloud_firestore/cloud_firestore.dart';

class VerificationService {
  final _db = FirebaseFirestore.instance;

  Future<void> saveVerification({
    required String agentId,
    required String plaque,
    required String resultat,
  }) async {
    await _db.collection('verifications').add({
      'agentId': agentId,
      'plaque': plaque,
      'resultat': resultat,
      'date': Timestamp.now(),
    });
  }
}
