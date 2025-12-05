import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../citizen/citizen_home_screen.dart'; // ✅ importe ton CitizenHome
import '../citizen/citizen_help_screen.dart'; // ✅ importe ton nouvel écran Conseils

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    final user = FirebaseAuth.instance.currentUser;

    if (index == 0) {
      // ✅ Citoyen
      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CitizenHomeScreen()),
        );
      } else {
        Navigator.pushNamed(context, '/login');
      }
    } else if (index == 1) {
      // ✅ Conseils citoyens
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CitizenHelpScreen()),
      );
    } else if (index == 2) {
      // ✅ Police
      Navigator.pushNamed(context, '/policeLogin');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text("Signalement de Vol")),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.person, size: 64, color: Colors.white),
                  SizedBox(height: 8),
                  Text("Bienvenue",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  Text(
                    user != null ? "Utilisateur connecté" : "Invité",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.public),
              title: Text("Signalements publics"),
              onTap: () => Navigator.pushNamed(context, '/publicFeed'),
            ),
            if (user != null) ...[
              ListTile(
                leading: Icon(Icons.assignment),
                title: Text("Mes signalements"),
                onTap: () => Navigator.pushNamed(context, '/myReports'),
              ),
              ListTile(
                leading: Icon(Icons.add_circle),
                title: Text("Créer un signalement"),
                onTap: () => Navigator.pushNamed(context, '/createReport'),
              ),
              ListTile(
                leading: Icon(Icons.motorcycle),
                title: Text("Mes motos"),
                onTap: () => Navigator.pushNamed(context, '/myMotos'),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Déconnexion"),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ] else ...[
              ListTile(
                leading: Icon(Icons.login),
                title: Text("Connexion"),
                onTap: () => Navigator.pushNamed(context, '/login'),
              ),
              ListTile(
                leading: Icon(Icons.app_registration),
                title: Text("Créer un compte"),
                onTap: () => Navigator.pushNamed(context, '/register'),
              ),
            ],
          ],
        ),
      ),

      // ✅ Hub principal dans le body
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bienvenue dans l'application",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            _accessCard(
              icon: Icons.person,
              title: "Espace Citoyen",
              description: "Déclarez vos motos et vos signalements.",
              route: '/citizenHomeScreen',
            ),
            SizedBox(height: 16),

            _accessCard(
              icon: Icons.info_outline,
              title: "Conseils citoyens",
              description: "Découvrez les démarches administratives et les conseils pratiques.",
              route: '/citizenHelp',
            ),
            SizedBox(height: 16),

            _accessCard(
              icon: Icons.shield,
              title: "Espace Police",
              description: "Accédez aux signalements validés et aux outils de suivi.",
              route: '/policeLogin',
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Citoyen",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: "Conseils",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shield),
            label: "Police",
          ),
        ],
      ),
    );
  }

  // ✅ Widget réutilisable pour les cartes du hub
  Widget _accessCard({
    required IconData icon,
    required String title,
    required String description,
    required String route,
  }) {
    return Card(
      color: Color(0xFF1A2A3D),
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
                Icon(icon, size: 32, color: Colors.lightBlueAccent),
                SizedBox(width: 12),
                Text(title,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlueAccent)),
              ],
            ),
            SizedBox(height: 8),
            Text(description, style: TextStyle(color: Colors.white70)),
            SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Navigator.pushNamed(context, route),
                child: Text("Accéder"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
