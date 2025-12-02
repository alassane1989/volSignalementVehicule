import 'MotoDocuments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Moto {
  final String id;
  final String userId;
  final String immatriculation;
  final String marque;
  final String modele;
  final String couleur;
  final  String annee;
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

  factory Moto.fromMap(Map<String, dynamic> map) => Moto(
    id: map['id'],
    userId: map['userId'],
    immatriculation: map['immatriculation'],
    marque: map['marque'],
    modele: map['modele'],
    couleur: map['couleur'],
    annee: map['annee'],
    numeroChassis: map['numeroChassis'],
    documents: MotoDocuments.fromMap(map['documents']),
  );

  Map<String, dynamic> toMap() => {
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
