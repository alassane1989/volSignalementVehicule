import 'dart:convert';
import 'package:http/http.dart' as http;

class PlateApiService {
  static const String baseUrl = "https://api.exemple.com";

  Future<Map<String, dynamic>?> verifyPlate(String plate) async {
    final url = Uri.parse("$baseUrl/verify?plate=$plate");

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        try {
          return jsonDecode(response.body) as Map<String, dynamic>;
        } catch (e) {
          print("Erreur parsing JSON: $e");
          return null;
        }
      } else {
        print("Erreur API: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Erreur réseau: $e");
      return null;
    }
  }
}
