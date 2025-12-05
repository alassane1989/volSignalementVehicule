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

  factory MotoDocuments.fromMap(Map<String, dynamic> map) {
    return MotoDocuments(
      carteGriseUrl: (map['carteGriseUrl'] ?? "") as String,
      factureUrl: (map['factureUrl'] ?? "") as String,
      photoMotoUrl: (map['photoMotoUrl'] ?? "") as String,
      photoPlaqueUrl: (map['photoPlaqueUrl'] ?? "") as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'carteGriseUrl': carteGriseUrl,
      'factureUrl': factureUrl,
      'photoMotoUrl': photoMotoUrl,
      'photoPlaqueUrl': photoPlaqueUrl,
    };
  }
}
