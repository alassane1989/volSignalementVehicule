import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  final _nomController = TextEditingController();
  final _emailController = TextEditingController();

  DateTime _dateHeureVol = DateTime.now();
  Moto? _selectedMoto;
  String? _selectedType;
  bool _loading = false;

  final _reportService = ReportService();
  final _motoService = MotoService();

  List<Moto> _motos = [];
  List<String> _photos = [];
  final ImagePicker _picker = ImagePicker();

  GeoPoint? _currentLocation;

  @override
  void initState() {
    super.initState();
    _loadMotos();
    _getLocation(); // récupérer localisation dès l’ouverture
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

  // ✅ SUPPRIMER PHOTO
  void _removePhoto(String url) {
    setState(() {
      _photos.remove(url);
    });
  }

  // ✅ LOCALISATION GPS sécurisée
  Future<GeoPoint> _getLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception("Service désactivé");

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("Permission refusée");
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception("Permission refusée définitivement");
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(Duration(seconds: 10), onTimeout: () {
        throw Exception("Timeout localisation");
      });

      final geo = GeoPoint(pos.latitude, pos.longitude);
      setState(() => _currentLocation = geo);
      return geo;
    } catch (e) {
      print("Erreur localisation: $e");
      return GeoPoint(0, 0);
    }
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
    if (!_formKey.currentState!.validate()) return;

    final user = fb.FirebaseAuth.instance.currentUser;
    final location = _currentLocation ?? await _getLocation();

    // Déterminer rôle
    final role = user != null ? "citizen" : "guest";

    // Validation invité
    if (role == "guest") {
      if ((_nomController.text.isEmpty && _emailController.text.isEmpty) || _photos.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Nom ou email et une photo sont obligatoires pour un invité")),
        );
        return;
      }
    }

    final report = Report(
      id: "",
      userId: user?.uid ?? "",
      role: role,
      nom: role == "guest" ? _nomController.text : null,
      email: role == "guest" ? _emailController.text : null,
      type: _selectedType ?? "",
      description: _descriptionController.text,
      photo: _photos.isNotEmpty ? _photos.first : "",
      motoId: _selectedMoto?.id,
      plaque: _selectedMoto?.immatriculation,
      dateHeureVol: _dateHeureVol,
      localisation: location,
      statut: 'a_verifier',
      createdAt: DateTime.now(),
    );

    setState(() => _loading = true);
    await _reportService.createReportAuto(report);
    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Signalement créé avec succès")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = fb.FirebaseAuth.instance.currentUser;
    final role = user != null ? "citizen" : "guest";

    return Scaffold(
      appBar: AppBar(title: Text("Déclarer un vol ou une perte")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // ✅ Type de signalement
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Type de signalement"),
                items: ["vehicule", "document", "objet", "cambriolage"]
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedType = val),
                validator: (val) => val == null ? "Sélectionnez un type" : null,
              ),

              SizedBox(height: 16),

              // ✅ Si type = véhicule → sélectionner une moto
              if (_selectedType == "vehicule")
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
                      _selectedType == "vehicule" && value == null ? "Sélectionnez une moto" : null,
                ),

              SizedBox(height: 16),

              // ✅ Champs invités
              if (role == "guest") ...[
                TextFormField(
                  controller: _nomController,
                  decoration: InputDecoration(labelText: "Nom"),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: "Email"),
                ),
                SizedBox(height: 16),
              ],

              // ✅ Date et heure
              ListTile(
                title: Text("Date et heure du vol/perte"),
                subtitle: Text(
                  "${_dateHeureVol.day}/${_dateHeureVol.month}/${_dateHeureVol.year} "
                  "à ${_dateHeureVol.hour}:${_dateHeureVol.minute}",
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: _selectDateHeure,
              ),

              SizedBox(height: 16),

              // ✅ Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Description des circonstances",
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    (val == null || val.trim().isEmpty) ? "Décrivez brièvement le vol/perte" : null,
              ),

              SizedBox(height: 24),

                      // ✅ Photos
              Text("Photos (obligatoire si invité)", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ..._photos.map((url) => Stack(
                        children: [
                          Image.network(url, width: 80, height: 80, fit: BoxFit.cover),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: GestureDetector(
                              onTap: () => _removePhoto(url),
                              child: Container(
                                color: Colors.black54,
                                child: Icon(Icons.close, color: Colors.white, size: 16),
                              ),
                            ),
                          ),
                        ],
                      )),
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

              // ✅ Localisation affichée si disponible
              if (_currentLocation != null) ...[
                Text("Localisation détectée", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Container(
                  height: 200,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(_currentLocation!.latitude, _currentLocation!.longitude),
                      zoom: 15,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId("vol"),
                        position: LatLng(_currentLocation!.latitude, _currentLocation!.longitude),
                      ),
                    },
                  ),
                ),
                SizedBox(height: 24),
              ],

              // ✅ Bouton d'envoi
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
