import 'package:flutter/material.dart';
import '../../services/ocr_service.dart';
import '../../services/plate_api_service.dart';
import '../../services/verification_service.dart';

class ScanPlateScreen extends StatefulWidget {
  @override
  _ScanPlateScreenState createState() => _ScanPlateScreenState();
}

class _ScanPlateScreenState extends State<ScanPlateScreen> {
  String? plate;
  Map<String, dynamic>? apiData;
  bool loading = false;
  String message = "";

  final ocr = OcrService();
  final api = PlateApiService();
  final history = VerificationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F1E33),
      appBar: AppBar(title: Text("Scan de plaque")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  loading = true;
                  plate = null;
                  apiData = null;
                  message = "";
                });

                final result = await ocr.scanPlate();
                if (result == null) {
                  setState(() {
                    loading = false;
                    message = "Aucune plaque détectée.";
                  });
                  return;
                }

                setState(() {
                  plate = result;
                });

                final data = await api.verifyPlate(result);
                setState(() {
                  apiData = data;
                  loading = false;
                });

                await history.saveVerification(
                  agentId: "UID_POLICE",
                  plaque: result,
                  resultat: data == null ? "non trouvée" : "ok",
                );
              },
              child: Text("Scanner la plaque"),
            ),
            SizedBox(height: 20),
            if (loading) CircularProgressIndicator(color: Colors.white),
            if (message.isNotEmpty)
              Text(message, style: TextStyle(color: Colors.redAccent)),
            if (plate != null)
              Text("Plaque détectée : $plate",
                  style: TextStyle(color: Colors.white)),
            if (apiData != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("✅ Véhicule officiel trouvé",
                      style: TextStyle(color: Colors.greenAccent)),
                  Text("Marque : ${apiData!['marque']}",
                      style: TextStyle(color: Colors.white)),
                  Text("Modèle : ${apiData!['modele']}",
                      style: TextStyle(color: Colors.white)),
                  Text("Couleur : ${apiData!['couleur']}",
                      style: TextStyle(color: Colors.white)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
