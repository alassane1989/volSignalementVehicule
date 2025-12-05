import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

import '../../models/Moto.dart';
import '../../models/MotoDocuments.dart';
import '../../services/MotoService.dart';

class AddMotoScreen extends StatefulWidget {
  @override
  State<AddMotoScreen> createState() => _AddMotoScreenState();
}

class _AddMotoScreenState extends State<AddMotoScreen> {
  final _formKey = GlobalKey<FormState>();

  final immatCtrl = TextEditingController();
  final marqueCtrl = TextEditingController();
  final modeleCtrl = TextEditingController();
  final couleurCtrl = TextEditingController();
  final anneeCtrl = TextEditingController();

  bool _loading = false;

  MotoDocuments docs = MotoDocuments.empty();
  final picker = ImagePicker();
  final _motoService = MotoService();

  // ✅ Upload générique
  Future<String> _uploadFile(XFile file, String folder) async {
    final ref = FirebaseStorage.instance.ref().child(
      "$folder/${DateTime.now().millisecondsSinceEpoch}.jpg",
    );

    await ref.putFile(File(file.path));
    return await ref.getDownloadURL();
  }

  // ✅ Menu d’upload
  void _showUploadMenu() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.picture_as_pdf),
              title: Text("Carte grise"),
              onTap: () => _pickDoc("carteGrise"),
            ),
            ListTile(
              leading: Icon(Icons.receipt),
              title: Text("Facture"),
              onTap: () => _pickDoc("facture"),
            ),
            ListTile(
              leading: Icon(Icons.motorcycle),
              title: Text("Photo de la moto"),
              onTap: () => _pickDoc("photoMoto"),
            ),
            ListTile(
              leading: Icon(Icons.confirmation_number),
              title: Text("Photo de la plaque"),
              onTap: () => _pickDoc("photoPlaque"),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Upload selon le type
  Future<void> _pickDoc(String type) async {
    Navigator.pop(context);

    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    final url = await _uploadFile(file, "motos/$type");

    setState(() {
      if (type == "carteGrise")
        docs = MotoDocuments(
          carteGriseUrl: url,
          factureUrl: docs.factureUrl,
          photoMotoUrl: docs.photoMotoUrl,
          photoPlaqueUrl: docs.photoPlaqueUrl,
        );
      if (type == "facture")
        docs = MotoDocuments(
          carteGriseUrl: docs.carteGriseUrl,
          factureUrl: url,
          photoMotoUrl: docs.photoMotoUrl,
          photoPlaqueUrl: docs.photoPlaqueUrl,
        );
      if (type == "photoMoto")
        docs = MotoDocuments(
          carteGriseUrl: docs.carteGriseUrl,
          factureUrl: docs.factureUrl,
          photoMotoUrl: url,
          photoPlaqueUrl: docs.photoPlaqueUrl,
        );
      if (type == "photoPlaque")
        docs = MotoDocuments(
          carteGriseUrl: docs.carteGriseUrl,
          factureUrl: docs.factureUrl,
          photoMotoUrl: docs.photoMotoUrl,
          photoPlaqueUrl: url,
        );
    });
  }

  // ✅ Enregistrer la moto
  Future<void> _saveMoto() async {
    if (!_formKey.currentState!.validate()) return;

    final user = fb.FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _loading = true);

    final moto = Moto(
      id: "",
      userId: user.uid,
      immatriculation: immatCtrl.text.trim(),
      marque: marqueCtrl.text.trim(),
      modele: modeleCtrl.text.trim(),
      couleur: couleurCtrl.text.trim(),
      annee: anneeCtrl.text.trim(),
      numeroChassis: "",
      documents: docs,
    );

    await _motoService.createMotoAuto(moto);

    setState(() => _loading = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Moto enregistrée avec succès")));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Enregistrer une moto")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: immatCtrl,
                decoration: InputDecoration(labelText: "Immatriculation"),
              ),
              TextFormField(
                controller: marqueCtrl,
                decoration: InputDecoration(labelText: "Marque"),
              ),
              TextFormField(
                controller: modeleCtrl,
                decoration: InputDecoration(labelText: "Modèle"),
              ),
              TextFormField(
                controller: couleurCtrl,
                decoration: InputDecoration(labelText: "Couleur"),
              ),
              TextFormField(
                controller: anneeCtrl,
                decoration: InputDecoration(labelText: "Année"),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: _showUploadMenu,
                child: Text("Ajouter documents"),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: _loading ? null : _saveMoto,
                child: _loading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Enregistrer"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
