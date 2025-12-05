import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CitizenHomeScreen extends StatefulWidget {
  const CitizenHomeScreen({super.key});

  @override
  State<CitizenHomeScreen> createState() => _CitizenHomeScreenState();
}

class _CitizenHomeScreenState extends State<CitizenHomeScreen> {
  String userName = "";
  String userEmail = "";
  String? photoUrl;

  int motoCount = 0;
  int reportCount = 0;
  int pendingCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadStats();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      final nom = data['nom'] ?? "";
      final prenom = data['prenom'] ?? "";

      setState(() {
        userName = "$prenom $nom".trim();
        userEmail = data['email'] ?? "";
        photoUrl = data['photoUrl']; // optionnel
      });
    }
  }

  Future<void> _loadStats() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final uid = user.uid;

    // ✅ Nombre de motos
    final motos = await FirebaseFirestore.instance
        .collection('motos')
        .where('userId', isEqualTo: uid)
        .get();

    // ✅ Nombre de signalements
    final reports = await FirebaseFirestore.instance
        .collection('reports')
        .where('userId', isEqualTo: uid)
        .get();

    // ✅ Nombre de signalements en cours
    final pending = reports.docs.where((d) => d['status'] == 'en cours').length;

    setState(() {
      motoCount = motos.docs.length;
      reportCount = reports.docs.length;
      pendingCount = pending;
    });
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      appBar: AppBar(
        title: Text("Espace Citoyen"),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: _loadStats),
          IconButton(icon: Icon(Icons.logout), onPressed: _logout),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildAnimatedHeader(),
            SizedBox(height: 20),
            _buildDashboard(),
            SizedBox(height: 20),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  // ✅ HEADER ANIMÉ
  Widget _buildAnimatedHeader() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 600),
      padding: EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A2A3D), Color(0xFF0F1E33)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.blueAccent,
            backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
            child: photoUrl == null
                ? Icon(Icons.person, size: 40, color: Colors.white)
                : null,
          ),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              userName.isEmpty ? "Bienvenue " : "Bienvenue $userName ",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ DASHBOARD VISUEL
  Widget _buildDashboard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _statCard(Icons.motorcycle, "Motos", motoCount),
          _statCard(Icons.report, "Signalements", reportCount),
          _statCard(Icons.timelapse, "En cours", pendingCount),
        ],
      ),
    );
  }

  Widget _statCard(IconData icon, String label, int value) {
    return Container(
      width: 110,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1A2A3D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: Colors.lightBlueAccent),
          SizedBox(height: 10),
          Text(
            "$value",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(label, style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  // ✅ ACTIONS RAPIDES
  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _menuButton(
            icon: Icons.report,
            title: "Déclarer un vol",
            route: '/createReport',
          ),
          SizedBox(height: 15),
          _menuButton(
            icon: Icons.list_alt,
            title: "Mes signalements",
            route: '/myReports',
          ),
          SizedBox(height: 15),
          _menuButton(
            icon: Icons.motorcycle,
            title: "Mes motos",
            route: '/myMotos',
          ),
        ],
      ),
    );
  }

  // ✅ BOUTON MODERNE
  Widget _menuButton({
    required IconData icon,
    required String title,
    required String route,
  }) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Color(0xFF1A2A3D),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 32, color: Colors.lightBlueAccent),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.lightBlueAccent),
          ],
        ),
      ),
    );
  }

  // ✅ MENU LATÉRAL (DRAWER) — VERSION RECOMMANDÉE
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Color(0xFF0F1E33),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF1A2A3D)),
            accountName: Text(
              userName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              userEmail,
              style: TextStyle(color: Colors.white70),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              backgroundImage: photoUrl != null
                  ? NetworkImage(photoUrl!)
                  : null,
              child: photoUrl == null
                  ? Icon(Icons.person, size: 40, color: Colors.white)
                  : null,
            ),
          ),

          // ✅ Nouveau bouton : Mon Profil
          ListTile(
            leading: Icon(Icons.person, color: Colors.white),
            title: Text("Mon profil"),
            onTap: () => Navigator.pushNamed(context, '/editProfile'),
          ),

          ListTile(
            leading: Icon(Icons.motorcycle, color: Colors.white),
            title: Text("Mes motos"),
            onTap: () => Navigator.pushNamed(context, '/myMotos'),
          ),
          ListTile(
            leading: Icon(Icons.add_circle, color: Colors.white),
            title: Text("Ajouter une moto"),
            onTap: () => Navigator.pushNamed(context, '/addMoto'),
          ),

          ListTile(
            leading: Icon(Icons.report, color: Colors.white),
            title: Text("Mes signalements"),
            onTap: () => Navigator.pushNamed(context, '/myReports'),
          ),

          ListTile(
            leading: Icon(Icons.settings, color: Colors.white),
            title: Text("Paramètres"),
          ),

          ListTile(
            leading: Icon(Icons.logout, color: Colors.redAccent),
            title: Text("Déconnexion"),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}
