import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Report.dart';

class ReportService {
  final _db = FirebaseFirestore.instance;
  final _collection = 'reports';

  /// ✅ Création automatique de l'ID Firestore
  Future<String> createReportAuto(Report report) async {
    final docRef = _db.collection(_collection).doc();
    final autoId = docRef.id;

    final reportWithId = Report(
      id: autoId,
      userId: report.userId,
      motoId: report.motoId,
      plaque: report.plaque,
      dateHeureVol: report.dateHeureVol,
      localisation: report.localisation,
      statut: report.statut,
      photos: report.photos,
      createdAt: report.createdAt,
    );

    await docRef.set(reportWithId.toMap());
    return autoId;
  }

  /// ✅ Récupérer les reports d'un utilisateur
  Stream<List<Report>> getReportsByUser(String userId) {
    return _db
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Report.fromMap(doc.data())).toList());
  }

  /// ✅ Récupérer un report par ID
  Future<Report?> getReportById(String id) async {
    final doc = await _db.collection(_collection).doc(id).get();
    if (!doc.exists) return null;
    return Report.fromMap(doc.data()!);
  }

  /// ✅ Récupérer les reports d'une moto
  Future<List<Report>> getReportsByMoto(String motoId) async {
    final snapshot = await _db
        .collection(_collection)
        .where('motoId', isEqualTo: motoId)
        .get();

    return snapshot.docs
        .map((doc) => Report.fromMap(doc.data()))
        .toList();
  }

  /// ✅ Vérifier une plaque (module Police)
  Future<Map<String, dynamic>?> getReportByPlate(String plate) async {
    final query = await _db
        .collection(_collection)
        .where('plaque', isEqualTo: plate)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;
    return query.docs.first.data();
  }

  /// ✅ Mettre à jour le statut
  Future<void> updateReportStatus(String reportId, String newStatus) async {
    await _db.collection(_collection).doc(reportId).update({
      'statut': newStatus,
    });
  }

  /// ✅ Supprimer un report
  Future<void> deleteReport(String id) async {
    await _db.collection(_collection).doc(id).delete();
  }
}
