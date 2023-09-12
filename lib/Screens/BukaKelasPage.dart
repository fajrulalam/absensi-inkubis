import 'dart:html';

import 'package:absensi_inkubis/Screens/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ListKelasPage.dart';

class BukaKelasPage extends StatefulWidget {
  static const String id = 'buka-kelas-page';
  String? documentId; //timestamp string

  BukaKelasPage({this.documentId});

  @override
  State<BukaKelasPage> createState() => _BukaKelasPageState();
}

class _BukaKelasPageState extends State<BukaKelasPage> {
  final GlobalKey<_BukaKelasPageState> refreshKey =
      GlobalKey<_BukaKelasPageState>();

  String mataPelajaran = '';
  String kelas = '';
  String kodeKelas = '000000';
  Timestamp waktuMulai = Timestamp.now();
  Timestamp waktuSelesai = Timestamp.now();
  int jumlahHadir = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();

    Stream stream = FirebaseFirestore.instance
        .collection('AbsenKelasCollection')
        .doc(widget.documentId)
        .collection('SiswaHadirCollection')
        .snapshots();

    stream.listen((event) {
      //count how many documents in collection
      setState(() {
        jumlahHadir = event.docs.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.documentId == 'default'
            ? Text('Pilih Kelas',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 16))
            : Text('$kelas - $mataPelajaran',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: widget.documentId == 'default'
          ? Center(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Card(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Lihat daftar kelas yang sudah dibuka',
                                style: GoogleFonts.poppins(
                                    color: Colors.pink,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, ListKelasPage.id);
                                  },
                                  child: Text(
                                    'List Kelas',
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 16),
                      width: 150,
                      height: 80,
                      child: Card(
                        child: Center(
                          child: Text(
                            kodeKelas[0] +
                                kodeKelas[1] +
                                ' ' +
                                kodeKelas[2] +
                                kodeKelas[3] +
                                ' ' +
                                kodeKelas[4] +
                                kodeKelas[5],
                            style: GoogleFonts.poppins(
                                color: Colors.pink,
                                fontSize: 32,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Text(widget.documentId!),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 1.5,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('AbsenKelasCollection')
                            .doc(widget.documentId)
                            .collection('SiswaHadirCollection')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            print(snapshot.data!.docs.length);
                            return GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount:
                                            MediaQuery.of(context).size.width >
                                                    800
                                                ? 8
                                                : 5,
                                        mainAxisSpacing: 8,
                                        crossAxisSpacing: 8,
                                        childAspectRatio: 3 / 4),
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot documentSnapshot =
                                      snapshot.data!.docs[index];
                                  return Container(
                                    margin: EdgeInsets.all(8),
                                    child: Card(
                                      elevation: 4,
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2,
                                                child: DetermineFoto(
                                                    documentSnapshot['foto'],
                                                    documentSnapshot[
                                                        'jenisKelamin']),
                                              ),
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  documentSnapshot['nama'],
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ))
                ],
              ),
            ),
      bottomNavigationBar: BottomAppBar(
          child: Container(
              padding: EdgeInsets.all(8),
              height: 50,
              child: Row(
                children: [
                  Text(
                    'Jumlah hadir: $jumlahHadir',
                    style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ))),
    );
  }

  void getData() {
    print('ini jalan');
    FirebaseFirestore.instance
        .collection('AbsenKelasCollection')
        .doc(widget.documentId)
        .get()
        .then((value) {
      //make a map that stores the value
      Map<String, dynamic> data = value.data() as Map<String, dynamic>;
      //assign the value to the variable
      setState(() {
        mataPelajaran = data['mataPelajaran'];
        kelas = data['kelas'];
        kodeKelas = data['kodeKelas'];
        waktuMulai = data['waktuMulai'];
        waktuSelesai = data['waktuSelesai'];
      });
    });
  }

  Widget DetermineFoto(String foto, String jenisKelamin) {
    if (foto == 'default' && jenisKelamin == 'Laki-Laki') {
      return Image.asset(
        'assets/ic_profile_cowo.png',
        fit: BoxFit.cover,
      );
    } else if (foto == 'default' && jenisKelamin == 'Perempuan') {
      return Image.asset(
        'assets/ic_profile_cewe.png',
        fit: BoxFit.cover,
      );
    } else {
      return Image.network(
        foto,
        fit: BoxFit.cover,
      );
    }
  }
}
