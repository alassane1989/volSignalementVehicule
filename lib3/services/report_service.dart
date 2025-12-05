import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Report.dart';

class ReportService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'reports';

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

  /// ✅ Récupérer les reports d'un utilisateur (Stream temps réel)
  Stream<List<Report>> getReportsStream(String userId) {
    return _db
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Report.fromMap(doc.data() ?? {}, doc.id))
            .toList());
  }

  /// ✅ Récupérer un report par ID
  Future<Report?> getReportById(String id) async {
    final doc = await _db.collection(_collection).doc(id).get();
    if (!doc.exists) return null;
    return Report.fromMap(doc.data() ?? {}, doc.id);
  }

  /// ✅ Récupérer les reports d'une moto
  Future<List<Report>> getReportsByMoto(String motoId) async {
    final snapshot = await _db
        .collection(_collection)
        .where('motoId', isEqualTo: motoId)
        .get();

    return snapshot.docs
        .map((doc) => Report.fromMap(doc.data() ?? {}, doc.id))
        .toList();
  }

  /// ✅ Vérifier une plaque (module Police)
  Future<Report?> getReportByPlate(String plate) async {
    final query = await _db
        .collection(_collection)
        .where('plaque', isEqualTo: plate)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;
    return Report.fromMap(query.docs.first.data() ?? {}, query.docs.first.id);
  }

  /// ✅ Mettre à jour le statut
  Future<void> updateReportStatus(String reportId, String newStatus) async {
    try {
      await _db.collection(_collection).doc(reportId).update({
        'statut': newStatus,
      });
    } catch (e) {
      print("Erreur updateReportStatus: $e");
    }
  }

  /// ✅ Supprimer un report
  Future<void> deleteReport(String id) async {
    try {
      await _db.collection(_collection).doc(id).delete();
    } catch (e) {
      print("Erreur deleteReport: $e");
    }
  }

  /// ✅ Récupérer tous les reports (Police/Admin)
  Future<List<Report>> getAllReports() async {
    final snapshot = await _db.collection(_collection).get();
    return snapshot.docs
        .map((doc) => Report.fromMap(doc.data() ?? {}, doc.id))
        .toList();
  }

  /// ✅ Stream global (Police/Admin)
  Stream<List<Report>> getAllReportsStream() {
    return _db.collection(_collection).snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Report.fromMap(doc.data() ?? {}, doc.id)).toList());
  }
}
