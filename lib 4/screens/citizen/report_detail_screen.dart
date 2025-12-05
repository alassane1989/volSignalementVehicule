import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/Report.dart';
import '../../services/report_service.dart';
import 'edit_report_screen.dart';

class ReportDetailScreen extends StatefulWidget {
  final String reportId;

  const ReportDetailScreen({required this.reportId});

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  final _reportService = ReportService();
  Report? _report;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final r = await _reportService.getReportById(widget.reportId);
    setState(() => _report = r);
  }

  Color _statusColor(String statut) {
    switch (statut) {
      case "a_verifier":
        return Colors.orange;
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

  Future<void> _confirmDelete() async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Supprimer"),
        content: Text("Voulez-vous vraiment supprimer ce signalement ?"),
        actions: [
          TextButton(
            child: Text("Annuler"),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            child: Text("Supprimer"),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _reportService.deleteReport(_report!.id);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_report == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final r = _report!;
    final date = DateFormat("dd MMM yyyy - HH:mm").format(r.dateHeureVol);

    return Scaffold(
      appBar: AppBar(
        title: Text("Détail du signalement"),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditReportScreen(report: r),
                ),
              ).then((_) => _load());
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _confirmDelete,
          ),
        ],
      ),

      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // ✅ Type du signalement
          Text("Type : ${r.type}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),

          // ✅ Coordonnées invité si role = guest
          if (r.role == "guest") ...[
            Text("Nom : ${r.nom ?? '-'}"),
            Text("Email : ${r.email ?? '-'}"),
            SizedBox(height: 12),
          ],

          // ✅ Plaque si véhicule
          if (r.type == "vehicule" && r.plaque != null)
            Text("Plaque : ${r.plaque}", style: TextStyle(fontSize: 18)),

          SizedBox(height: 12),

          // ✅ Statut avec couleur
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: _statusColor(r.statut),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8),
              Text("Statut : ${r.statut}", style: TextStyle(fontSize: 18)),
            ],
          ),

          SizedBox(height: 12),

          // ✅ Date formatée
          Text("Date : $date", style: TextStyle(fontSize: 16)),
          SizedBox(height: 12),

          // ✅ Description
          Text("Description :", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 6),
          Text(r.description),
          SizedBox(height: 16),

          // ✅ Localisation
          Text("Localisation :", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 6),
          Text("${r.localisation.latitude}, ${r.localisation.longitude}"),
          SizedBox(height: 16),

          // ✅ Photos
          Text("Photos :", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),

          Wrap(
            spacing: 8,
            children: [
              ...r.photos.map((url) => ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(url, width: 120, height: 120, fit: BoxFit.cover),
                  )),
              if (r.photos.isEmpty && r.photo.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(r.photo, width: 120, height: 120, fit: BoxFit.cover),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
