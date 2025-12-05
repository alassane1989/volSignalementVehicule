import 'package:flutter/material.dart';
import '../../models/Report.dart';
import '../../services/report_service.dart';

class EditReportScreen extends StatefulWidget {
  final Report report;

  const EditReportScreen({required this.report});

  @override
  State<EditReportScreen> createState() => _EditReportScreenState();
}

class _EditReportScreenState extends State<EditReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reportService = ReportService();

  late String _selectedStatus;
  bool _loading = false;

  final List<String> _statusOptions = [
    "en_attente",
    "en_cours",
    "valide",
    "rejete",
    "resolu",
  ];

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.report.statut;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    await _reportService.updateReportStatus(
      widget.report.id,
      _selectedStatus,
    );

    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Signalement mis à jour")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Modifier le signalement")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: InputDecoration(labelText: "Statut"),
                items: _statusOptions
                    .map((s) => DropdownMenuItem(
                          value: s,
                          child: Text(s),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _selectedStatus = value!);
                },
                validator: (v) =>
                    v == null || v.isEmpty ? "Sélectionnez un statut" : null,
              ),

              SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _save,
                  child: _loading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("Enregistrer"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
