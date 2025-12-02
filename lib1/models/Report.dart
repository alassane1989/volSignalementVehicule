import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  final String id;
  final String userId;
  final String motoId;
  final String plaque;
  final DateTime dateHeureVol;
  final GeoPoint localisation;
  final String statut;
  final List<String> photos;
  final DateTime createdAt;

  Report({
    required this.id,
    required this.userId,
    required this.motoId,
    required this.plaque,
    required this.dateHeureVol,
    required this.localisation,
    required this.statut,
    required this.photos,
    required this.createdAt,
  });

  factory Report.fromMap(Map<String, dynamic> map, String docId) {
    return Report(
      id: map['id'] ?? docId, // ✅ utilise l'id du document si absent
      userId: map['userId'] ?? '',
      motoId: map['motoId'] ?? '',
      plaque: map['plaque'] ?? '',
      dateHeureVol: (map['dateHeureVol'] as Timestamp).toDate(),
      localisation: map['localisation'] as GeoPoint,
      statut: map['statut'] ?? 'en_attente',
      photos: List<String>.from(map['photos'] ?? []),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'motoId': motoId,
      'plaque': plaque,
      'dateHeureVol': Timestamp.fromDate(dateHeureVol),
      'localisation': localisation,
      'statut': statut,
      'photos': photos,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
