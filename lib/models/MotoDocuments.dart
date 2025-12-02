class MotoDocuments {
  final String carteGriseUrl;
  final String factureUrl;
  final String photoMotoUrl;
  final String photoPlaqueUrl;

  MotoDocuments({
    required this.carteGriseUrl,
    required this.factureUrl,
    required this.photoMotoUrl,
    required this.photoPlaqueUrl,
  });

  // ✅ Constructeur vide
  MotoDocuments.empty()
      : carteGriseUrl = "",
        factureUrl = "",
        photoMotoUrl = "",
        photoPlaqueUrl = "";

  factory MotoDocuments.fromMap(Map<String, dynamic> map) => MotoDocuments(
        carteGriseUrl: map['carteGriseUrl'] ?? "",
        factureUrl: map['factureUrl'] ?? "",
        photoMotoUrl: map['photoMotoUrl'] ?? "",
        photoPlaqueUrl: map['photoPlaqueUrl'] ?? "",
      );

  Map<String, dynamic> toMap() => {
        'carteGriseUrl': carteGriseUrl,
        'factureUrl': factureUrl,
        'photoMotoUrl': photoMotoUrl,
        'photoPlaqueUrl': photoPlaqueUrl,
      };
}
