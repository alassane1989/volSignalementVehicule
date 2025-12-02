import 'package:flutter/material.dart';
import '../../services/report_service.dart';

class VerifyPlateScreen extends StatefulWidget {
  @override
  _VerifyPlateScreenState createState() => _VerifyPlateScreenState();
}

class _VerifyPlateScreenState extends State<VerifyPlateScreen> {
  final plateCtrl = TextEditingController();
  final service = ReportService();

  Map<String, dynamic>? result;
  bool loading = false;
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F1E33),
      appBar: AppBar(title: Text("Vérifier une plaque")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: plateCtrl,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Plaque d'immatriculation",
                labelStyle: TextStyle(color: Colors.white70),
              ),
            ),
            SizedBox(height: 20),
            loading
                ? CircularProgressIndicator(color: Colors.white)
                : ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        loading = true;
                        error = "";
                        result = null;
                      });

                      final data = await service.getReportByPlate(
                        plateCtrl.text.trim(),
                      );

                      setState(() {
                        loading = false;
                        result = data;
                        if (data == null) {
                          error = "Aucun signalement trouvé pour cette plaque.";
                        }
                      });
                    },
                    child: Text("Vérifier"),
                  ),
            SizedBox(height: 20),
            if (error.isNotEmpty)
              Text(error, style: TextStyle(color: Colors.redAccent)),
            if (result != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("🚨 Véhicule signalé comme volé !",
                      style: TextStyle(color: Colors.orange, fontSize: 18)),
                  SizedBox(height: 10),
                  Text("Marque : ${result!['marque']}",
                      style: TextStyle(color: Colors.white)),
                  Text("Modèle : ${result!['modele']}",
                      style: TextStyle(color: Colors.white)),
                  Text("Couleur : ${result!['couleur']}",
                      style: TextStyle(color: Colors.white)),
                  Text("Plaque : ${result!['plaque']}",
                      style: TextStyle(color: Colors.white)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
