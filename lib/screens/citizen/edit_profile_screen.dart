import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final nomCtrl = TextEditingController();
  final prenomCtrl = TextEditingController();
  final telCtrl = TextEditingController();

  String? photoUrl;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    if (doc.exists) {
      final data = doc.data()!;
      nomCtrl.text = data['nom'] ?? "";
      prenomCtrl.text = data['prenom'] ?? "";
      telCtrl.text = data['telephone'] ?? "";
      photoUrl = data['photoUrl'];
    }

    setState(() => loading = false);
  }

  Future<void> _saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      "nom": nomCtrl.text.trim(),
      "prenom": prenomCtrl.text.trim(),
      "telephone": telCtrl.text.trim(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Profil mis à jour")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(title: Text("Modifier mon profil")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Modifier mon profil")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            Center(
              child: CircleAvatar(
                radius: 45,
                backgroundColor: Colors.blueAccent,
                backgroundImage:
                    photoUrl != null ? NetworkImage(photoUrl!) : null,
                child: photoUrl == null
                    ? Icon(Icons.person, size: 50, color: Colors.white)
                    : null,
              ),
            ),

            SizedBox(height: 20),

            TextField(
              controller: nomCtrl,
              decoration: InputDecoration(labelText: "Nom"),
            ),

            TextField(
              controller: prenomCtrl,
              decoration: InputDecoration(labelText: "Prénom"),
            ),

            TextField(
              controller: telCtrl,
              decoration: InputDecoration(labelText: "Téléphone"),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: _saveProfile,
              child: Text("Enregistrer"),
            ),
          ],
        ),
      ),
    );
  }
}
