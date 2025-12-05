import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/PoliceCheck.dart';

class PoliceCheckService {
  final CollectionReference<Map<String, dynamic>> checksRef =
      FirebaseFirestore.instance.collection('policeChecks');

  /// ✅ Ajouter une vérification
  Future<void> addCheck(PoliceCheck check) async {
    try {
      await checksRef.doc(check.id).set(check.toMap());
    } catch (e) {
      print("Erreur addCheck: $e");
    }
  }

  /// ✅ Récupérer les vérifications d’un policier
  Future<List<PoliceCheck>> getChecksByPolice(String policeId) async {
    final snapshot =
        await checksRef.where('policeId', isEqualTo: policeId).get();

    return snapshot.docs
        .map((doc) => PoliceCheck.fromMap(doc.data() ?? {}, doc.id))
        .toList();
  }

  /// ✅ Stream temps réel des vérifications d’un policier
  Stream<List<PoliceCheck>> getChecksStreamByPolice(String policeId) {
    return checksRef
        .where('policeId', isEqualTo: policeId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PoliceCheck.fromMap(doc.data() ?? {}, doc.id))
            .toList());
  }

  /// ✅ Supprimer une vérification
  Future<void> deleteCheck(String id) async {
    try {
      await checksRef.doc(id).delete();
    } catch (e) {
      print("Erreur deleteCheck: $e");
    }
  }

  /// ✅ Récupérer toutes les vérifications (vue globale Police/Admin)
  Future<List<PoliceCheck>> getAllChecks() async {
    final snapshot = await checksRef.get();
    return snapshot.docs
        .map((doc) => PoliceCheck.fromMap(doc.data() ?? {}, doc.id))
        .toList();
  }

  /// ✅ Stream global (Police/Admin)
  Stream<List<PoliceCheck>> getAllChecksStream() {
    return checksRef.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => PoliceCheck.fromMap(doc.data() ?? {}, doc.id)).toList());
  }
}
