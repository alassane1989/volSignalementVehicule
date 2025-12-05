import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class PoliceMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFF0A1A2F),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF1E3A5F)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.shield, size: 60, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  "Police Nationale",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard, color: Colors.white),
            title: Text("Dashboard", style: TextStyle(color: Colors.white)),
            onTap: () => Navigator.pushNamed(context, '/policeDashboard'),
          ),
          ListTile(
            leading: Icon(Icons.search, color: Colors.white),
            title: Text(
              "Vérifier une plaque",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => Navigator.pushNamed(context, '/verifyPlate'),
          ),
          ListTile(
            leading: Icon(Icons.camera_alt, color: Colors.white),
            title: Text(
              "Scanner une plaque",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/scanPlate');
            },
          ),

          ListTile(
            leading: Icon(Icons.history, color: Colors.white),
            title: Text("Historique des vérifications"),
            onTap: () {
              Navigator.pushNamed(context, '/verificationHistory');
            },
          ),

          ListTile(
            leading: Icon(Icons.logout, color: Colors.white),
            title: Text("Déconnexion", style: TextStyle(color: Colors.white)),
            onTap: () async {
              final confirm = await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Confirmation"),
                    content: Text("Voulez-vous vraiment vous déconnecter ?"),
                    actions: [
                      TextButton(
                        child: Text("Annuler"),
                        onPressed: () => Navigator.pop(context, false),
                      ),
                      TextButton(
                        child: Text("Oui"),
                        onPressed: () => Navigator.pop(context, true),
                      ),
                    ],
                  );
                },
              );

              if (confirm != true) return;

              Navigator.pop(context);

              await FirebaseAuth.instance.signOut();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Déconnexion réussie"),
                  backgroundColor: Colors.green,
                ),
              );

              Future.delayed(Duration(milliseconds: 500), () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/policeLogin',
                  (route) => false,
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
