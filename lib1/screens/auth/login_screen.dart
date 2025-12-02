import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool _loading = false;

  Future<void> _login() async {
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veuillez remplir tous les champs")),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      // ✅ Connexion Firebase
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );

      final uid = cred.user!.uid;

      // ✅ Récupération du rôle dans Firestore
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (!doc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Utilisateur sans rôle défini")),
        );
        return;
      }

      final role = doc['role'];

      // ✅ Redirection selon le rôle
      if (role == "police") {
        Navigator.pushReplacementNamed(context, '/policeDashboard');
      } else {
        Navigator.pushReplacementNamed(context, '/citizenHome');
      }

    } on FirebaseAuthException catch (e) {
      String message = "Erreur inconnue";

      if (e.code == 'user-not-found') message = "Utilisateur introuvable";
      if (e.code == 'wrong-password') message = "Mot de passe incorrect";
      if (e.code == 'invalid-email') message = "Email invalide";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Connexion")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: emailCtrl,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passCtrl,
              decoration: InputDecoration(labelText: "Mot de passe"),
              obscureText: true,
            ),

            SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _login,
                child: _loading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Se connecter"),
              ),
            ),

            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: Text("Créer un compte"),
            ),
          ],
        ),
      ),
    );
  }
}
