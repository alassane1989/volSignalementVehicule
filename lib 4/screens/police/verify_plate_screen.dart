import 'package:flutter/material.dart';
import '../../services/report_service.dart';
import '../../models/Report.dart';

class VerifyPlateScreen extends StatefulWidget {
  @override
  _VerifyPlateScreenState createState() => _VerifyPlateScreenState();
}

class _VerifyPlateScreenState extends State<VerifyPlateScreen> {
  final plateCtrl = TextEditingController();
  final service = ReportService();

  Report? result; // ✅ maintenant c'est un Report
  bool loading = false;
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1E33),
      appBar: AppBar(title: const Text("Vérifier une plaque")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: plateCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Plaque d'immatriculation",
                labelStyle: TextStyle(color: Colors.white70),
              ),
            ),
            const SizedBox(height: 20),
            loading
                ? const CircularProgressIndicator(color: Colors.white)
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
                        result = data; // ✅ assignation correcte
                        if (data == null) {
                          error = "Aucun signalement trouvé pour cette plaque.";
                        }
                      });
                    },
                    child: const Text("Vérifier"),
                  ),
            const SizedBox(height: 20),
            if (error.isNotEmpty)
              Text(error, style: const TextStyle(color: Colors.redAccent)),
            if (result != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "🚨 Véhicule signalé comme volé !",
                    style: TextStyle(color: Colors.orange, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text("Moto ID : ${result!.motoId}",
                      style: const TextStyle(color: Colors.white)),
                  Text("Plaque : ${result!.plaque}",
                      style: const TextStyle(color: Colors.white)),
                  Text("Statut : ${result!.statut}",
                      style: const TextStyle(color: Colors.white)),
                  Text(
                    "Date du vol : ${result!.dateHeureVol}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
