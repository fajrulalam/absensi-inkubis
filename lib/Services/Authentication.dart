import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signInwWithCredential(
      {required String providerId, required String signInMethod}) async {
    await _firebaseAuth.signInWithCredential(
        AuthCredential(providerId: providerId, signInMethod: signInMethod));
  }

  Future<void> createUserWithEmailAndPssword(
      {required String email,
      required String password,
      required String nama,
      required String asrama,
      required String jenisAkun,
      required String jenisKelamin}) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    String uid = userCredential.user!.uid;
    await FirebaseFirestore.instance
        .collection('UsersCollection')
        .doc(uid)
        .set({
      'nama': nama,
      'email': email,
      'role': jenisAkun,
      'timestampRegistrasi': DateTime.now(),
      'asrama': asrama,
      'role': jenisAkun,
      'jenisKelamin': jenisKelamin,
      'foto': 'default',
      'isVerified': false,
    });
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
