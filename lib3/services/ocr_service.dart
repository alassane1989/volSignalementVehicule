import 'dart:math';

class OcrService {
  /// Simule une détection OCR sur une image
  Future<String?> scanPlate({String? imagePath}) async {
    try {
      // Simule un délai de traitement OCR
      await Future.delayed(const Duration(seconds: 2));

      // Simulation : génère une plaque aléatoire
      final random = Random();
      final plaque = "TG-${1000 + random.nextInt(8999)}-${String.fromCharCode(65 + random.nextInt(26))}${String.fromCharCode(65 + random.nextInt(26))}";
      
      return plaque;
    } catch (e) {
      print("Erreur OCR: $e");
      return null; // si OCR échoue
    }
  }
}
