import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

import '../../models/Moto.dart';
import '../../services/MotoService.dart';
import 'edit_moto_screen.dart';

class MyMotosScreen extends StatelessWidget {
  final _motoService = MotoService();

  @override
  Widget build(BuildContext context) {
    final user = fb.FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text("Mes motos")),
      body: StreamBuilder<List<Moto>>(
        stream: _motoService.getMotosStream(user!.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final motos = snapshot.data!;
          if (motos.isEmpty) {
            return Center(child: Text("Aucune moto enregistrée"));
          }

          return ListView.builder(
            itemCount: motos.length,
            itemBuilder: (_, i) {
              final m = motos[i];
              return Card(
                child: ListTile(
                  title: Text("${m.immatriculation} - ${m.marque} ${m.modele}"),
                  subtitle: Text("Couleur : ${m.couleur}"),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditMotoScreen(moto: m),
                      ),
                    );
                  },
                ),
              );
            },
            
          );
        },
      ),
    );
  }
}
