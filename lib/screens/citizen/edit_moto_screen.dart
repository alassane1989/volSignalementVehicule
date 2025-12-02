import 'package:flutter/material.dart';
import '../../models/Moto.dart';
import '../../services/MotoService.dart';

class EditMotoScreen extends StatefulWidget {
  final Moto moto;

  const EditMotoScreen({required this.moto});

  @override
  State<EditMotoScreen> createState() => _EditMotoScreenState();
}

class _EditMotoScreenState extends State<EditMotoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _motoService = MotoService();

  late TextEditingController immatCtrl;
  late TextEditingController marqueCtrl;
  late TextEditingController modeleCtrl;
  late TextEditingController couleurCtrl;
  late TextEditingController anneeCtrl;

  @override
  void initState() {
    super.initState();
    immatCtrl = TextEditingController(text: widget.moto.immatriculation);
    marqueCtrl = TextEditingController(text: widget.moto.marque);
    modeleCtrl = TextEditingController(text: widget.moto.modele);
    couleurCtrl = TextEditingController(text: widget.moto.couleur);
    anneeCtrl = TextEditingController(text: widget.moto.annee);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final updatedMoto = Moto(
      id: widget.moto.id,
      userId: widget.moto.userId,
      immatriculation: immatCtrl.text.trim(),
      marque: marqueCtrl.text.trim(),
      modele: modeleCtrl.text.trim(),
      couleur: couleurCtrl.text.trim(),
      annee: anneeCtrl.text.trim(),
      numeroChassis: widget.moto.numeroChassis,
      documents: widget.moto.documents,
    );

    await _motoService.updateMoto(updatedMoto);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Moto mise à jour")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Modifier la moto")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(controller: immatCtrl, decoration: InputDecoration(labelText: "Immatriculation")),
              TextFormField(controller: marqueCtrl, decoration: InputDecoration(labelText: "Marque")),
              TextFormField(controller: modeleCtrl, decoration: InputDecoration(labelText: "Modèle")),
              TextFormField(controller: couleurCtrl, decoration: InputDecoration(labelText: "Couleur")),
              TextFormField(controller: anneeCtrl, decoration: InputDecoration(labelText: "Année")),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _save, child: Text("Enregistrer")),
            ],
          ),
        ),
      ),
    );
  }
}
