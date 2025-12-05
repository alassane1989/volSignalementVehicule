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
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final motos = snapshot.data!;
          if (motos.isEmpty) {
            return Center(child: Text("Aucune moto enregistrée"));
          }

          return ListView.builder(
            itemCount: motos.length,
            itemBuilder: (_, i) {
              final m = motos[i];
              return Dismissible(
                key: Key(m.id), // chaque moto doit avoir un id unique
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 20),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                secondaryBackground: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text("Confirmation"),
                      content: Text(
                        "Voulez-vous vraiment supprimer cette moto ?",
                      ),
                      actions: [
                        TextButton(
                          child: Text("Annuler"),
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                        TextButton(
                          child: Text(
                            "Supprimer",
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () => Navigator.of(context).pop(true),
                        ),
                      ],
                    ),
                  );
                },
                onDismissed: (_) async {
                  await _motoService.deleteMoto(m.id);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Moto supprimée")));
                },
                child: Card(
                  child: ListTile(
                    title: Text(
                      "${m.immatriculation} - ${m.marque} ${m.modele}",
                    ),
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
