import 'package:cloud_firestore/cloud_firestore.dart';


class PoliceCheck {
  final String id;
  final String policeId;
  final String plaqueVerifiee;
  final String resultat;
  final GeoPoint localisation;
  final DateTime dateHeure;

  PoliceCheck({
    required this.id,
    required this.policeId,
    required this.plaqueVerifiee,
    required this.resultat,
    required this.localisation,
    required this.dateHeure,
  });

  factory PoliceCheck.fromMap(Map<String, dynamic> map) => PoliceCheck(
    id: map['id'],
    policeId: map['policeId'],
    plaqueVerifiee: map['plaqueVerifiee'],
    resultat: map['resultat'],
    localisation: map['localisation'],
    dateHeure: (map['dateHeure'] as Timestamp).toDate(),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'policeId': policeId,
    'plaqueVerifiee': plaqueVerifiee,
    'resultat': resultat,
    'localisation': localisation,
    'dateHeure': Timestamp.fromDate(dateHeure),
  };
}
