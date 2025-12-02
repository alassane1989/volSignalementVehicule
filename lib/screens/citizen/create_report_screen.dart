import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';

import '../../models/Moto.dart';
import '../../models/Report.dart';
import '../../services/report_service.dart';
import '../../services/MotoService.dart';

class CreateReportScreen extends StatefulWidget {
  @override
  State<CreateReportScreen> createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends State<CreateReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  DateTime _dateHeureVol = DateTime.now();
  Moto? _selectedMoto;
  bool _loading = false;

  final _reportService = ReportService();
  final _motoService = MotoService();

  List<Moto> _motos = [];
  List<String> _photos = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadMotos();
  }

  Future<void> _loadMotos() async {
    final user = fb.FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final motos = await _motoService.getMotosByUser(user.uid);
    setState(() {
      _motos = motos;
    });
  }

  // ✅ UPLOAD PHOTO
  Future<void> _pickPhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final storageRef = FirebaseStorage.instance
        .ref()
        .child("reports/${DateTime.now().millisecondsSinceEpoch}.jpg");

    await storageRef.putFile(File(image.path));
    final url = await storageRef.getDownloadURL();

    setState(() {
      _photos.add(url);
    });
  }

  // ✅ LOCALISATION GPS
  Future<GeoPoint> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    final pos = await Geolocator.getCurrentPosition();
    return GeoPoint(pos.latitude, pos.longitude);
  }

  Future<void> _selectDateHeure() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dateHeureVol,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dateHeureVol),
    );
    if (time == null) return;

    setState(() {
      _dateHeureVol = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _submit() async {
    if (_selectedMoto == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Veuillez sélectionner une moto")));
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    final user = fb.FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _loading = true);

    // ✅ Récupération de la localisation réelle
    final location = await _getLocation();

    final report = Report(
      id: "",
      userId: user.uid,
      motoId: _selectedMoto!.id,
      plaque: _selectedMoto!.immatriculation,
      dateHeureVol: _dateHeureVol,
      localisation: location,
      statut: 'en_attente',
      photos: _photos, // ✅ photos uploadées
      createdAt: DateTime.now(),
    );

    await _reportService.createReportAuto(report);

    setState(() => _loading = false);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Signalement créé avec succès")));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Déclarer un vol")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _motos.isEmpty
            ? Center(
                child: Text(
                  "Vous devez d'abord enregistrer une moto.",
                  style: TextStyle(color: Colors.grey[700]),
                ),
              )
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    DropdownButtonFormField<Moto>(
                      decoration: InputDecoration(labelText: "Moto concernée"),
                      items: _motos
                          .map(
                            (m) => DropdownMenuItem(
                              value: m,
                              child: Text("${m.immatriculation} - ${m.marque} ${m.modele}"),
                            ),
                          )
                          .toList(),
                      onChanged: (moto) => setState(() => _selectedMoto = moto),
                      validator: (value) =>
                          value == null ? "Sélectionnez une moto" : null,
                    ),

                    SizedBox(height: 16),

                    ListTile(
                      title: Text("Date et heure du vol"),
                      subtitle: Text(
                        "${_dateHeureVol.day}/${_dateHeureVol.month}/${_dateHeureVol.year} "
                        "à ${_dateHeureVol.hour}:${_dateHeureVol.minute}",
                      ),
                      trailing: Icon(Icons.calendar_today),
                      onTap: _selectDateHeure,
                    ),

                    SizedBox(height: 16),

                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: "Description des circonstances",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                          (val == null || val.trim().isEmpty)
                              ? "Décrivez brièvement le vol"
                              : null,
                    ),

                    SizedBox(height: 24),

                    Text("Photos du vol", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),

                    Wrap(
                      spacing: 8,
                      children: [
                        ..._photos.map((url) => Image.network(url, width: 80, height: 80)),
                        GestureDetector(
                          onTap: _pickPhoto,
                          child: Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[300],
                            child: Icon(Icons.add_a_photo),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _submit,
                        child: _loading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text("Envoyer le signalement"),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
