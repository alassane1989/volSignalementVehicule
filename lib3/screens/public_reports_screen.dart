import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../../services/MotoService.dart';
import '../../services/report_service.dart';
import '../../models/Moto.dart';
import '../../models/Report.dart';

class PublicReportsScreen extends StatelessWidget {
  final _motoService = MotoService();
  final _reportService = ReportService();

  Color _statusColor(String statut) {
    switch (statut) {
      case "en_attente":
        return Colors.orange;
      case "resolu":
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Signalements publics")),
      body: FutureBuilder<List<Moto>>(
        future: _motoService.getAllMotos(), // ⚠️ à implémenter dans MotoService
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Aucune moto enregistrée"));
          }

          final motos = snapshot.data!;
          return ListView.builder(
            itemCount: motos.length,
            itemBuilder: (context, index) {
              final moto = motos[index];
              return FutureBuilder<List<Report>>(
                future: _reportService.getReportsByMoto(moto.id),
                builder: (context, reportSnap) {
                  String statut = "";
                  if (reportSnap.hasData && reportSnap.data!.isNotEmpty) {
                    statut = reportSnap.data!.first.statut;
                  }

                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: ListTile(
                      title: Text("${moto.marque} ${moto.modele}"),
                      subtitle: Text(
                        "Plaque : ${moto.immatriculation}\n"
                        "${statut.isNotEmpty ? "Statut : $statut" : "Aucun signalement"}",
                      ),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: statut.isEmpty
                              ? Colors.blue
                              : _statusColor(statut),
                        ),
                        onPressed: () {
                          final user = fb.FirebaseAuth.instance.currentUser;
                          if (user == null) {
                            Navigator.pushNamed(context, '/register');
                          } else {
                            Navigator.pushNamed(context, '/createReport',
                                arguments: moto);
                          }
                        },
                        child: Text(
                          statut.isEmpty
                              ? "Signaler"
                              : statut == "resolu"
                                  ? "Résolu"
                                  : "En cours",
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
