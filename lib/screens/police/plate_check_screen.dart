import 'package:flutter/material.dart';

class PlateCheckScreen extends StatelessWidget {
  final plateCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Vérification de plaque")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: plateCtrl,
              decoration: InputDecoration(labelText: "Numéro de plaque"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text("Rechercher"),
            ),
          ],
        ),
      ),
    );
  }
}
