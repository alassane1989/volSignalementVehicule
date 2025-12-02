class OcrService {
  Future<String?> scanPlate() async {
    // Simule une détection OCR
    await Future.delayed(Duration(seconds: 2));
    return "TG-1234-AA"; // à remplacer par vraie détection
  }
}
