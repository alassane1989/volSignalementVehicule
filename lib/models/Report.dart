import 'package:cloud_firestore/cloud_firestore.dart';


class Report {
  final String id;
  final String userId;
  final String motoId;
  final String plaque;          // ✅ NOUVEAU
  final DateTime dateHeureVol;
  final GeoPoint localisation;
  final String statut;
  final List<String> photos;
  final DateTime createdAt;

  Report({
    required this.id,
    required this.userId,
    required this.motoId,
    required this.plaque,       // ✅ NOUVEAU
    required this.dateHeureVol,
    required this.localisation,
    required this.statut,
    required this.photos,
    required this.createdAt,
  });

  factory Report.fromMap(Map<String, dynamic> map) => Report(
        id: map['id'],
        userId: map['userId'],
        motoId: map['motoId'],
        plaque: map['plaque'],   // ✅ NOUVEAU
        dateHeureVol: (map['dateHeureVol'] as Timestamp).toDate(),
        localisation: map['localisation'],
        statut: map['statut'],
        photos: List<String>.from(map['photos']),
        createdAt: (map['createdAt'] as Timestamp).toDate(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'motoId': motoId,
        'plaque': plaque,        // ✅ NOUVEAU
        'dateHeureVol': Timestamp.fromDate(dateHeureVol),
        'localisation': localisation,
        'statut': statut,
        'photos': photos,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
