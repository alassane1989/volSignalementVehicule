import 'package:flutter/material.dart';

class PoliceHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F1E33),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shield, size: 120, color: Colors.lightBlueAccent),
            SizedBox(height: 20),
            Text(
              "Espace Police",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Accès réservé aux forces de l’ordre.\nConnexion sécurisée.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/policeLogin'),
              child: Text("Connexion Police"),
            ),
          ],
        ),
      ),
    );
  }
}
