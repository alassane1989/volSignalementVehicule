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

  /// ✅ Récupérer toutes les motos d’un utilisateur
  Future<List<Moto>> getMotosByUser(String userId) async {
    final snapshot = await _db
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs
        .map((doc) => Moto.fromMap(doc.data() ?? {}, doc.id))
        .toList();
  }

  /// ✅ Stream des motos d’un utilisateur (temps réel)
  Stream<List<Moto>> getMotosStream(String userId) {
    return _db
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Moto.fromMap(doc.data() ?? {}, doc.id))
            .toList());
  }

  /// ✅ Récupérer une moto par ID
  Future<Moto?> getMotoById(String motoId) async {
    final doc = await _db.collection(_collection).doc(motoId).get();
    if (!doc.exists) return null;

    return Moto.fromMap(doc.data() ?? {}, doc.id);
  }

  /// ✅ Récupérer une moto par plaque
  Future<Moto?> getMotoByPlate(String plate) async {
    final query = await _db
        .collection(_collection)
        .where('immatriculation', isEqualTo: plate)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;

    final first = query.docs.first;
    return Moto.fromMap(first.data() ?? {}, first.id);
  }

  /// ✅ Mise à jour d’une moto
  Future<void> updateMoto(Moto moto) async {
    try {
      await _db.collection(_collection).doc(moto.id).update(moto.toMap());
    } catch (e) {
      print("Erreur updateMoto: $e");
    }
  }

  /// ✅ Suppression d’une moto
  Future<void> deleteMoto(String id) async {
    try {
      await _db.collection(_collection).doc(id).delete();
    } catch (e) {
      print("Erreur deleteMoto: $e");
    }
  }

  /// ✅ Récupérer toutes les motos (Police)
  Future<List<Moto>> getAllMotos() async {
    final snapshot = await _db.collection(_collection).get();

    return snapshot.docs
        .map((doc) => Moto.fromMap(doc.data() ?? {}, doc.id))
        .toList();
  }

  /// ✅ Stream global (Police)
  Stream<List<Moto>> getAllMotosStream() {
    return _db.collection(_collection).snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Moto.fromMap(doc.data() ?? {}, doc.id)).toList());
  }
}
