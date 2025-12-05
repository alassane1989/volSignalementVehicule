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

  /// ✅ Factory avec docId en paramètre
  factory PoliceCheck.fromMap(Map<String, dynamic> map, String docId) {
    return PoliceCheck(
      id: map['id'] ?? docId,
      policeId: map['policeId'] ?? '',
      plaqueVerifiee: map['plaqueVerifiee'] ?? '',
      resultat: map['resultat'] ?? '',
      localisation: map['localisation'] is GeoPoint
          ? map['localisation'] as GeoPoint
          : const GeoPoint(0, 0),
      dateHeure: (map['dateHeure'] is Timestamp)
          ? (map['dateHeure'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'policeId': policeId,
      'plaqueVerifiee': plaqueVerifiee,
      'resultat': resultat,
      'localisation': localisation,
      'dateHeure': Timestamp.fromDate(dateHeure),
    };
  }
}
