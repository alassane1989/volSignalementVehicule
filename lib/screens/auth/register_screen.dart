import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nomCtrl = TextEditingController();
  final prenomCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final telCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  bool loading = false;

  Future<void> register() async {
    if (nomCtrl.text.isEmpty ||
        prenomCtrl.text.isEmpty ||
        emailCtrl.text.isEmpty ||
        telCtrl.text.isEmpty ||
        passCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veuillez remplir tous les champs")),
      );
      return;
    }

    try {
      setState(() => loading = true);

      // ✅ 1. Création du compte Firebase Auth
      UserCredential cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passCtrl.text.trim(),
      );

      final uid = cred.user!.uid;

      // ✅ 2. Enregistrement Firestore
      await FirebaseFirestore.instance.collection("users").doc(uid).set({
        "id": uid,
        "nom": nomCtrl.text.trim(),
        "prenom": prenomCtrl.text.trim(),
        "email": emailCtrl.text.trim(),
        "telephone": telCtrl.text.trim(),
        "role": "citizen",
        "createdAt": DateTime.now(),
      });

      // ✅ 3. Redirection vers l’espace citoyen
      Navigator.pushReplacementNamed(context, '/citizenHome');

    } on FirebaseAuthException catch (e) {
      String message = "Erreur inconnue";

      if (e.code == "email-already-in-use") {
        message = "Cet email est déjà utilisé";
      } else if (e.code == "weak-password") {
        message = "Mot de passe trop faible";
      } else if (e.code == "invalid-email") {
        message = "Email invalide";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Inscription")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            TextField(controller: nomCtrl, decoration: InputDecoration(labelText: "Nom")),
            TextField(controller: prenomCtrl, decoration: InputDecoration(labelText: "Prénom")),
            TextField(controller: emailCtrl, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: telCtrl, decoration: InputDecoration(labelText: "Téléphone")),
            TextField(controller: passCtrl, decoration: InputDecoration(labelText: "Mot de passe"), obscureText: true),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: loading ? null : register,
              child: loading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Créer mon compte"),
            ),
          ],
        ),
      ),
    );
  }
}
