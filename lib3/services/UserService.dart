import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/User.dart';

class UserService {
  final CollectionReference<Map<String, dynamic>> usersRef =
      FirebaseFirestore.instance.collection('users');

  /// ✅ Ajouter un utilisateur
  Future<void> addUser(User user) async {
    try {
      await usersRef.doc(user.id).set(user.toMap());
    } catch (e) {
      print("Erreur addUser: $e");
    }
  }

  /// ✅ Récupérer un utilisateur par ID
  Future<User?> getUser(String id) async {
    final doc = await usersRef.doc(id).get();
    if (!doc.exists) return null;

    return User.fromMap(doc.data() ?? {}, doc.id);
  }

  /// ✅ Stream temps réel d’un utilisateur
  Stream<User?> getUserStream(String id) {
    return usersRef.doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      return User.fromMap(doc.data() ?? {}, doc.id);
    });
  }

  /// ✅ Mettre à jour un utilisateur
  Future<void> updateUser(User user) async {
    try {
      await usersRef.doc(user.id).update(user.toMap());
    } catch (e) {
      print("Erreur updateUser: $e");
    }
  }

  /// ✅ Supprimer un utilisateur
  Future<void> deleteUser(String id) async {
    try {
      await usersRef.doc(id).delete();
    } catch (e) {
      print("Erreur deleteUser: $e");
    }
  }

  /// ✅ Récupérer tous les utilisateurs (utile côté Police/Admin)
  Future<List<User>> getAllUsers() async {
    final snapshot = await usersRef.get();
    return snapshot.docs
        .map((doc) => User.fromMap(doc.data() ?? {}, doc.id))
        .toList();
  }

  /// ✅ Stream global des utilisateurs
  Stream<List<User>> getAllUsersStream() {
    return usersRef.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => User.fromMap(doc.data() ?? {}, doc.id)).toList());
  }
}
