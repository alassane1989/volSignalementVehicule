import 'MotoDocuments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Moto {
  final String id;
  final String userId;
  final String immatriculation;
  final String marque;
  final String modele;
  final String couleur;
  final String annee;
  final String? numeroChassis;
  final MotoDocuments documents;

  Moto({
    required this.id,
    required this.userId,
    required this.immatriculation,
    required this.marque,
    required this.modele,
    required this.couleur,
    required this.annee,
    this.numeroChassis,
    required this.documents,
  });

  /// ✅ Factory avec docId en paramètre
  factory Moto.fromMap(Map<String, dynamic> map, String docId) {
    return Moto(
      id: map['id'] ?? docId, // si 'id' n’est pas stocké, on prend doc.id
      userId: map['userId'] ?? '',
      immatriculation: map['immatriculation'] ?? '',
      marque: map['marque'] ?? '',
      modele: map['modele'] ?? '',
      couleur: map['couleur'] ?? '',
      annee: map['annee'] ?? '',
      numeroChassis: map['numeroChassis'],
      documents: MotoDocuments.fromMap(map['documents'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'immatriculation': immatriculation,
      'marque': marque,
      'modele': modele,
      'couleur': couleur,
      'annee': annee,
      'numeroChassis': numeroChassis,
      'documents': documents.toMap(),
    };
  }
}
