import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Moto.dart';

class MotoService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'motos';

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

  Future<List<Moto>> getMotosByUser(String userId) async {
    final snapshot = await _db
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs
        .map((doc) => Moto.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Stream<List<Moto>> getMotosStream(String userId) {
    return _db
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Moto.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<Moto?> getMotoById(String motoId) async {
    final doc = await _db.collection(_collection).doc(motoId).get();
    if (!doc.exists) return null;

    final data = doc.data() as Map<String, dynamic>;
    return Moto.fromMap(data, doc.id);
  }

  Future<Moto?> getMotoByPlate(String plate) async {
    final query = await _db
        .collection(_collection)
        .where('immatriculation', isEqualTo: plate)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;

    final first = query.docs.first;
    return Moto.fromMap(first.data() as Map<String, dynamic>, first.id);
  }

  Future<void> updateMoto(Moto moto) async {
    await _db.collection(_collection).doc(moto.id).update(moto.toMap());
  }

  Future<void> deleteMoto(String id) async {
    await _db.collection(_collection).doc(id).delete();
  }

  Future<List<Moto>> getAllMotos() async {
    final snapshot = await _db.collection(_collection).get();

    return snapshot.docs
        .map((doc) => Moto.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }
}
