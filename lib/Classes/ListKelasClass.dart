import 'package:cloud_firestore/cloud_firestore.dart';

class Kelas {
  String id;
  String kelas;
  String kodeKelas;
  String mataPelajaran;
  String asrama;
  DateTime waktuMulai;
  DateTime waktuSelesai;
  String pengajar;
  int jumlahHadir;

  Kelas({
    required this.id,
    required this.kelas,
    required this.kodeKelas,
    required this.mataPelajaran,
    required this.waktuMulai,
    required this.waktuSelesai,
    required this.asrama,
    required this.pengajar,
    required this.jumlahHadir,
  });
}

class KelasClass {
  static List<Kelas> getKelasAktif(QuerySnapshot snapshot) {
    List<Kelas> kelasAktifList = [];

    //convert snapshot to a map
    snapshot.docs.forEach((element) {
      //convert to a map
      Map<String, dynamic> kelasAktif = element.data() as Map<String, dynamic>;
      //convert timestamp to datetime
      DateTime waktuMulai = kelasAktif['waktuMulai'].toDate();
      DateTime waktuSelesai = kelasAktif['waktuSelesai'].toDate();
      String kelas = kelasAktif['kelas'];
      String kodeKelas = kelasAktif['kodeKelas'];
      String mataPelajaran = kelasAktif['mataPelajaran'];
      String asrama = kelasAktif['asrama'];
      String pengajar = kelasAktif['pengajar'] ?? '-';
      int jumlahHadir = kelasAktif['jumlahHadir'] ?? 0;

      kelasAktifList.add(Kelas(
          id: element.id,
          kelas: kelas,
          kodeKelas: kodeKelas,
          mataPelajaran: mataPelajaran,
          waktuMulai: waktuMulai,
          asrama: asrama,
          waktuSelesai: waktuSelesai,
          pengajar: pengajar,
          jumlahHadir: jumlahHadir));
    });

    return kelasAktifList;
  }
}
