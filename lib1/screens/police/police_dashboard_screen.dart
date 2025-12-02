import 'package:flutter/material.dart';
import 'police_menu.dart';

class PoliceDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: PoliceMenu(),
      appBar: AppBar(
        title: Text("Dashboard Police"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Signalements récents",
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 3, // temporaire
                itemBuilder: (context, index) {
                  return Card(
                    color: Color(0xFF1E3A5F),
                    child: ListTile(
                      title: Text("Signalement #$index", style: TextStyle(color: Colors.white)),
                      subtitle: Text("Moto volée - Honda XRE", style: TextStyle(color: Colors.white70)),
                      onTap: () => Navigator.pushNamed(context, '/policeReportDetail'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
