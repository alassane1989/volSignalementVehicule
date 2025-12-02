import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String nom;
  final String prenom;
  final String email;
  final String telephone;
  final String adresse;
  final DateTime createdAt;

  User({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.telephone,
    required this.adresse,
    required this.createdAt,
  });

  factory User.fromMap(Map<String, dynamic> map) => User(
    id: map['id'],
    nom: map['nom'],
    prenom: map['prenom'],
    email: map['email'],
    telephone: map['telephone'],
    adresse: map['adresse'],
    createdAt: (map['createdAt'] as Timestamp).toDate(),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'nom': nom,
    'prenom': prenom,
    'email': email,
    'telephone': telephone,
    'adresse': adresse,
    'createdAt': Timestamp.fromDate(createdAt),
  };
}
