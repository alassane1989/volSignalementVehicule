import 'dart:convert';
import 'package:http/http.dart' as http;

class PlateApiService {
  Future<Map<String, dynamic>?> verifyPlate(String plate) async {
    final url = "https://api.exemple.com/verify?plate=$plate";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) return null;

    return jsonDecode(response.body);
  }
}
