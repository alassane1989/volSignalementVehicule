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
      role: report.role,          // citizen ou guest
      nom: report.nom,
      email: report.email,
      type: report.type,          // vehicule, document, objet, cambriolage...
      description: report.description,
      photo: report.photo,        // obligatoire si guest
      photos: report.photos,
      motoId: report.motoId,
      plaque: report.plaque,
      dateHeureVol: report.dateHeureVol,
      localisation: report.localisation,
      statut: report.statut,
      createdAt: report.createdAt,

      // ✅ nouveaux champs espace public
      isValidated: false,
      isPublic: true,
      publicScore: 0,
      visibilityAt: Timestamp.now(),
      
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

  /// ✅ Récupérer les reports d'une moto (si type = vehicule)
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

  // 🔥 Nouveaux services pour l’espace public

  /// ✅ Publier un report dans l’espace public
  Future<void> publishReport(String reportId) async {
    await _db.collection(_collection).doc(reportId).update({
      'isPublic': true,
      'visibilityAt': Timestamp.now(),
    });
  }

  /// ✅ Valider un report (Police/Admin)
  Future<void> validateReport(String reportId) async {
    await _db.collection(_collection).doc(reportId).update({
      'isValidated': true,
    });
  }

  /// ✅ Incrémenter le score de popularité (likes/commentaires)
  Future<void> incrementPublicScore(String reportId, int value) async {
    await _db.collection(_collection).doc(reportId).update({
      'publicScore': FieldValue.increment(value),
    });
  }

  /// ✅ Récupérer uniquement les reports publics validés
  Stream<List<Report>> getPublicReportsStream() {
    return _db
        .collection(_collection)
       // .where('isValidated', isEqualTo: true)
        .where('isPublic', isEqualTo: true)
      //  .orderBy('visibilityAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Report.fromMap(doc.data() ?? {}, doc.id)).toList());
  }
}
