import 'package:flutter/material.dart';

class CitizenHelpScreen extends StatelessWidget {
  const CitizenHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2A3D),
        title: const Text("Conseils citoyens"),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A2A3D), Color(0xFF0F1E33)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _helpCard(
              context,
              "En cas de vol de moto",
              "Déclarez immédiatement le vol dans l’application et rendez-vous au commissariat avec vos papiers.",
              Icons.report,
              "Déclarer un vol",
              '/createReport',
            ),
            _helpCard(
              context,
              "En cas d’accident",
              "Contactez les secours, ajoutez un rapport avec localisation précise et prévenez votre assurance.",
              Icons.local_hospital,
              "Ajouter un rapport",
              '/createReport',
            ),
            _helpCard(
              context,
              " Si vous êtes témoin",
              "Utilisez la fonction 'Partager' pour alerter d’autres citoyens et prévenir les autorités.",
              Icons.share,
              "Partager un signalement",
              '/publicFeedScreen',
            ),
            _helpCard(
              context,
              " Perte de papiers",
              "Déclarez la perte au commissariat, demandez un récépissé et déposez une demande de duplicata.",
              Icons.assignment,
              "Voir démarches",
              '/adminSteps', // tu peux créer un écran dédié
            ),
            _helpCard(
              context,
              "Démarches administratives",
              "Consultez vos signalements validés pour obtenir un suivi officiel et mettre à jour vos rapports.",
              Icons.check_circle,
              "Mes signalements",
              '/myReports',
            ),
          ],
        ),
      ),
    );
  }

  Widget _helpCard(BuildContext context, String title, String description,
      IconData icon, String actionLabel, String route) {
    return Card(
      color: const Color(0xFF1A2A3D),
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blueAccent.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.lightBlueAccent, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
                label: Text(actionLabel),
                onPressed: () {
                  Navigator.pushNamed(context, route);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
