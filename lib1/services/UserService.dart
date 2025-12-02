import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/User.dart';

class UserService {
  final CollectionReference<Map<String, dynamic>> usersRef =
      FirebaseFirestore.instance.collection('users');

  Future<void> addUser(User user) async {
    await usersRef.doc(user.id).set(user.toMap());
  }

  Future<User?> getUser(String id) async {
    final DocumentSnapshot<Map<String, dynamic>> doc =
        await usersRef.doc(id).get();

    if (!doc.exists) return null;

    return User.fromMap(doc.data()!);
  }

  Future<void> updateUser(User user) async {
    await usersRef.doc(user.id).update(user.toMap());
  }

  Future<void> deleteUser(String id) async {
    await usersRef.doc(id).delete();
  }
}
