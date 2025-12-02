import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Signalement de Vol"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == "login") {
                Navigator.pushNamed(context, '/login');
              } else if (value == "register") {
                Navigator.pushNamed(context, '/register');
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: "login", child: Text("Connexion")),
              PopupMenuItem(value: "register", child: Text("Créer un compte")),
            ],
          ),
        ],
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth = constraints.maxWidth;

          // ✅ Large écran → cartes centrées et plus larges
          double cardWidth = maxWidth > 600 ? 500 : maxWidth;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * 0.02),

                  Text(
                    "Bienvenue",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 8),

                  Text(
                    "Choisissez votre espace pour continuer",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),

                  SizedBox(height: size.height * 0.04),

                  // ✅ Espace Citoyen
                  SizedBox(
                    width: cardWidth,
                    child: _buildAccessCard(
                      context,
                      title: "Espace Citoyen",
                      icon: Icons.person,
                      description:
                          "Déclarez un vol, enregistrez vos motos et suivez vos signalements.",
                      buttonText: "Accéder",
                      onPressed: () => Navigator.pushNamed(context, '/login'),
                    ),
                  ),

                  // espace citoyen invité
                  SizedBox(height: size.height * 0.03),

                  // ✅ Espace Citoyen Invité (nouveau)
                  SizedBox(
                    width: cardWidth,
                    child: _buildAccessCard(
                      context,
                      title: "Espace Citoyen Invité",
                      icon: Icons.report_gmailerrorred, // Icône d’alerte
                      description:
                          "Signalez un vol, un accident ou un abus sans compte. Une identité valide est requise.",
                      buttonText: "Signaler un incident",
                      onPressed: () =>
                          Navigator.pushNamed(context, '/guestReport'),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  // ✅ Espace Police
                  SizedBox(
                    width: cardWidth,
                    child: _buildAccessCard(
                      context,
                      title: "Espace Police",
                      icon: Icons.shield,
                      description:
                          "Vérifiez les plaques, consultez les signalements et traitez les dossiers.",
                      buttonText: "Accéder",
                      onPressed: () =>
                          Navigator.pushNamed(context, '/policeLogin'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAccessCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String description,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF1A2A3D),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 90, color: Colors.lightBlueAccent),

          SizedBox(height: 20),

          Text(
            title,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 10),

          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70),
          ),

          SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              child: Text(buttonText),
            ),
          ),
        ],
      ),
    );
  }
}
