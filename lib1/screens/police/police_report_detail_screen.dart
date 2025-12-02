import 'package:flutter/material.dart';

class PoliceReportDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Détail du signalement")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Moto : Honda XRE", style: TextStyle(fontSize: 18)),
            Text("Plaque : TG-1234-AA"),
            Text("Couleur : Rouge"),
            SizedBox(height: 20),
            Text("Informations du citoyen :"),
            Text("Nom : Kossi Mensah"),
            Text("Téléphone : 90 00 00 00"),
            SizedBox(height: 20),
            Text("Localisation du vol :"),
            Text("Agoè - Carrefour"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text("Marquer comme vérifié"),
            ),
          ],
        ),
      ),
    );
  }
}
