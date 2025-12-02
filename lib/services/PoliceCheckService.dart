import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/PoliceCheck.dart';

class PoliceCheckService {
  final CollectionReference<Map<String, dynamic>> checksRef =
      FirebaseFirestore.instance.collection('policeChecks');

  Future<void> addCheck(PoliceCheck check) async {
    await checksRef.doc(check.id).set(check.toMap());
  }

  Future<List<PoliceCheck>> getChecksByPolice(String policeId) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await checksRef.where('policeId', isEqualTo: policeId).get();

    return snapshot.docs
        .map((doc) => PoliceCheck.fromMap(doc.data()))
        .toList();
  }

  Future<void> deleteCheck(String id) async {
    await checksRef.doc(id).delete();
  }
}
