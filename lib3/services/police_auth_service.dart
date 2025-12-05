import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PoliceAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// ✅ Connexion Police
  Future<bool> loginPolice(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final doc = await _db.collection('users').doc(cred.user!.uid).get();

      if (!doc.exists) return false;

      final role = doc.data()?['role'] ?? '';
      return role == 'police';
    } catch (e) {
      print("Erreur de connexion Police : $e");
      return false;
    }
  }

  /// ✅ Déconnexion
  Future<void> logoutPolice() async {
    await _auth.signOut();
  }

  /// ✅ Vérifier si un utilisateur est connecté et est Police
  Future<bool> isPoliceLoggedIn() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final doc = await _db.collection('users').doc(user.uid).get();
    if (!doc.exists) return false;

    final role = doc.data()?['role'] ?? '';
    return role == 'police';
  }
}
