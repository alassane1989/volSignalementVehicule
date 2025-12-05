import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  final String id;
  final String userId;       // citoyen connecté ou vide si invité
  final String role;         // "citizen" ou "guest"
  final String? nom;         // obligatoire si guest
  final String? email;       // obligatoire si guest
  final String type;         // vehicule, document, objet, cambriolage...
  final String description;  // détails du signalement
  final String photo;        // obligatoire si guest (URL Firebase Storage)
  final List<String> photos; // liste pour citizen     

  // ✅ Champs pour l’espace public
  final bool isValidated; 
  final bool isPublic;    
  final int publicScore;  
  final Timestamp? visibilityAt; // 🔥 nouveau champ
// ✅ Nouveau champ compteur de commentaires
  final int commentsCount;

  final String? motoId;      
  final String? plaque;      
  final DateTime dateHeureVol;
  final GeoPoint localisation;
  final String statut;       
  final DateTime createdAt;

  Report({
    required this.id,
    required this.userId,
    required this.role,
    this.nom,
    this.email,
    required this.type,
    required this.description,
    required this.photo,
    this.photos = const [],
    this.isValidated = false,
    this.isPublic = false,
    this.publicScore = 0,
    this.visibilityAt, // ✅ ajouté
     this.commentsCount = 0, // ✅ valeur par défaut
    this.motoId,
    this.plaque,
    required this.dateHeureVol,
    required this.localisation,
    required this.statut,
    required this.createdAt,
  });

  factory Report.fromMap(Map<String, dynamic> map, String docId) {
    return Report(
      id: docId,
      userId: map['userId'] ?? '',
      role: map['role'] ?? 'citizen',
      nom: map['nom'],
      email: map['email'],
      type: map['type'] ?? '',
      description: map['description'] ?? '',
      photo: map['photo'] ?? '',
      photos: List<String>.from(map['photos'] ?? []),
      isValidated: map['isValidated'] ?? false,
      isPublic: map['isPublic'] ?? false,
      publicScore: map['publicScore'] ?? 0,
      visibilityAt: map['visibilityAt'], // ✅ récupéré
      
      motoId: map['motoId'],
      plaque: map['plaque'],
      dateHeureVol: (map['dateHeureVol'] as Timestamp).toDate(),
      localisation: map['localisation'] as GeoPoint,
      statut: map['statut'] ?? 'a_verifier',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      commentsCount: map['commentsCount'] ?? 0, // ✅ lecture Firestore
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'role': role,
      'nom': nom,
      'email': email,
      'type': type,
      'description': description,
      'photo': photo,
      'photos': photos,
      'isValidated': isValidated,
      'isPublic': isPublic,
      'publicScore': publicScore,
      'visibilityAt': visibilityAt, // ✅ sauvegardé
       'commentsCount': commentsCount, // ✅ sauvegarde Firestore
      'motoId': motoId,
      'plaque': plaque,
      'dateHeureVol': Timestamp.fromDate(dateHeureVol),
      'localisation': localisation,
      'statut': statut,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
