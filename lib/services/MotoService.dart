import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Moto.dart';

class MotoService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'motos';

  /// ✅ Création automatique de l'ID Firestore
  Future<String> createMotoAuto(Moto moto) async {
    final docRef = _db.collection(_collection).doc();
    final autoId = docRef.id;

    final motoWithId = Moto(
      id: autoId,
      userId: moto.userId,
      immatriculation: moto.immatriculation,
      marque: moto.marque,
      modele: moto.modele,
      couleur: moto.couleur,
      annee: moto.annee,
      numeroChassis: moto.numeroChassis,
      documents: moto.documents,
    );

    await docRef.set(motoWithId.toMap());
    return autoId;
  }

  /// ✅ Récupérer toutes les motos d'un utilisateur (Future)
  Future<List<Moto>> getMotosByUser(String userId) async {
    final snapshot = await _db
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs
        .map((doc) => Moto.fromMap(doc.data()))
        .toList();
  }

  /// ✅ Récupérer les motos en temps réel (Stream)
  Stream<List<Moto>> getMotosStream(String userId) {
    return _db
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Moto.fromMap(doc.data())).toList());
  }

  /// ✅ Récupérer une moto par ID
  Future<Moto?> getMotoById(String motoId) async {
    final doc = await _db.collection(_collection).doc(motoId).get();
    if (!doc.exists) return null;
    return Moto.fromMap(doc.data()!);
  }

  /// ✅ Récupérer une moto par plaque (immatriculation)
  Future<Moto?> getMotoByPlate(String plate) async {
    final query = await _db
        .collection(_collection)
        .where('immatriculation', isEqualTo: plate)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;

    return Moto.fromMap(query.docs.first.data());
  }

  /// ✅ Mise à jour d'une moto
  Future<void> updateMoto(Moto moto) async {
    await _db.collection(_collection).doc(moto.id).update(moto.toMap());
  }

  /// ✅ Suppression d'une moto
  Future<void> deleteMoto(String id) async {
    await _db.collection(_collection).doc(id).delete();
  }
}
