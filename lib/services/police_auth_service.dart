import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PoliceAuthService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Future<bool> loginPolice(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final doc = await _db.collection('users').doc(cred.user!.uid).get();

      if (!doc.exists) return false;

      return doc['role'] == 'police';
    } catch (e) {
      print("Erreur de connexion Police : $e");
      return false;
    }
  }
}
