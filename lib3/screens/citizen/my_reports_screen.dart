import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:intl/intl.dart';

import '../../models/Report.dart';
import '../../services/report_service.dart';
import 'report_detail_screen.dart';

class MyReportsScreen extends StatelessWidget {
  final _reportService = ReportService();

  Color _statusColor(String statut) {
    switch (statut) {
      case "en_attente":
        return Colors.orange;
      case "en_cours":
        return Colors.blue;
      case "valide":
        return Colors.green;
      case "rejete":
        return Colors.red;
      case "resolu":
        return Colors.green.shade800;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = fb.FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text("Mes signalements")),
      body: StreamBuilder<List<Report>>(
        stream:  _reportService.getReportsStream(user!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Erreur de chargement"));
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final reports = snapshot.data!;
          if (reports.isEmpty) {
            return Center(child: Text("Aucun signalement pour le moment"));
          }

          return RefreshIndicator(
            onRefresh: () async {},
            child: ListView.builder(
              itemCount: reports.length,
              itemBuilder: (_, i) {
                final r = reports[i];
                final date = DateFormat("dd MMM yyyy - HH:mm").format(r.dateHeureVol);

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    leading: r.photos.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              r.photos.first,
                              width: 55,
                              height: 55,
                              fit: BoxFit.cover,
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor: _statusColor(r.statut),
                            child: Icon(Icons.report, color: Colors.white),
                          ),

                    title: Text("Vol du $date"),
                    subtitle: Text("Statut : ${r.statut}"),

                    trailing: Icon(Icons.chevron_right),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReportDetailScreen(reportId: r.id),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
