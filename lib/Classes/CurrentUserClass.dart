import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Services/Authentication.dart';

class CurrentUserObject {
  String? uid;
  String? nama;
  String? role;
  String? asrama;
  bool? isVerified;
  String? email;
  DateTime? timestampRegistrasi;
  String? foto;
  String? jenisKelamin;

  CurrentUserObject(
      {this.uid,
      this.nama,
      this.role,
      this.asrama,
      this.isVerified,
      this.email,
      this.timestampRegistrasi,
      this.foto,
      this.jenisKelamin});
}

class CurrentUserClass {
  final User? user = Auth().currentUser;

  Future<CurrentUserObject> getUserDetail() async {
    late CurrentUserObject currrentUserObject;

    print('user?.uid: ${user?.uid}');

    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("UsersCollection")
        .doc(user?.uid)
        .get();

    if (!documentSnapshot.exists) {
      currrentUserObject = CurrentUserObject(
        uid: user?.uid ?? '',
        nama: user?.displayName ?? '',
        role: 'Bukan Pengguna',
        isVerified: false,
        email: user?.email ?? '',
        foto: 'default',
        timestampRegistrasi: DateTime.now(),
      );
      return currrentUserObject;
    }

    Map<String, dynamic> map = documentSnapshot.data() as Map<String, dynamic>;
    String nama = map['nama'].toString();
    String role = map['role'].toString();
    String? asrama = map['asrama'].toString();
    bool isVerified = map['isVerified'] as bool;
    String email = map['email'].toString();
    String foto = map['foto'].toString();
    String jenisKelamin = map['jenisKelamin'].toString();
    DateTime timestampRegistrasi = map['timestampRegistrasi'].toDate();

    currrentUserObject = CurrentUserObject(
      uid: user?.uid ?? '',
      nama: nama,
      role: role,
      asrama: asrama,
      isVerified: isVerified,
      email: email,
      jenisKelamin: jenisKelamin,
      foto: foto,
      timestampRegistrasi: timestampRegistrasi,
    );

    return currrentUserObject;
  }
}
