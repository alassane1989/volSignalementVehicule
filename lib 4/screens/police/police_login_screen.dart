import 'package:flutter/material.dart';
import '../../services/police_auth_service.dart';

class PoliceLoginScreen extends StatefulWidget {
  @override
  _PoliceLoginScreenState createState() => _PoliceLoginScreenState();
}

class _PoliceLoginScreenState extends State<PoliceLoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final auth = PoliceAuthService();

  String error = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F1E33),
      appBar: AppBar(title: Text("Connexion Police")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: emailCtrl,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(color: Colors.white70),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: passCtrl,
              obscureText: true,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Mot de passe",
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
                      });

                      final ok = await auth.loginPolice(
                        emailCtrl.text.trim(),
                        passCtrl.text.trim(),
                      );

                      setState(() => loading = false);

                      if (ok) {
                        Navigator.pushNamed(context, '/policeDashboard');
                      } else {
                        setState(() => error =
                            "Email ou mot de passe incorrect, ou accès non autorisé.");
                      }
                    },
                    child: Text("Connexion"),
                  ),
            if (error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(error, style: TextStyle(color: Colors.redAccent)),
              ),
          ],
        ),
      ),
    );
  }
}
