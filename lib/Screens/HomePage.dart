import 'package:absensi_inkubis/Classes/CurrentUserClass.dart';
import 'package:absensi_inkubis/Screens/BukaKelasPage.dart';
import 'package:absensi_inkubis/Widgets/LoaderWidget.dart';
import 'package:absensi_inkubis/Widgets/PilihanKelasButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Services/Authentication.dart';
import 'ListKelasPage.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home-page';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  double spaceForButtons = 16;
  double spaceForKelas = 16;
  CurrentUserObject userDetail = CurrentUserObject(role: 'kosong');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, initialIndex: 0, vsync: this);
    getUserDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.grey,
        ),
        title: Row(
          children: [
            Text("Buka Kelas",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(
              width: 16,
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, ListKelasPage.id);
                    },
                    child: Text(
                      'List Kelas',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    )))
          ],
        ),
        actions: [
          Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: OutlinedButton(
                  onPressed: () {
                    Auth().signOut();
                  },
                  child: Text(
                    'Logout',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  )))
        ],
        centerTitle: false,
      ),
      body: userDetail.role == 'kosong'
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Container(
                      margin: EdgeInsets.only(left: 7),
                      child: Text('Memverifikasi User...')),
                ],
              ),
            )
          : (userDetail.role != 'Tutor' || userDetail.role != 'Admin') &&
                  userDetail.isVerified == false
              ? tidakAdaAkses()
              : verifiedAkses(),
    );
  }

  createKelas(
      String kelas, String kodeKelas, String mataPelajaran, String asrama) {
    Navigator.pop(context);
    DateTime now = DateTime.now();
    print(now.toString());
    LoaderWidget.showLoaderDialog(context, message: 'Membuat Kelas');
    FirebaseFirestore.instance
        .collection('AbsenKelasCollection')
        .doc(now.toString())
        .set({
      'kelas': kelas,
      'kodeKelas': kodeKelas,
      'mataPelajaran': mataPelajaran,
      'waktuMulai': now,
      'asrama': asrama,
      'pengajar': userDetail.nama,
      'jumlahHadir': 0,
      'waktuSelesai': now.add(Duration(hours: 1)),
    }).then((value) {
      Navigator.pop(context);
      Navigator.pushNamed(context, BukaKelasPage.id, arguments: now.toString());
    });
  }

  Widget tidakAdaAkses() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            child: Center(
                child: Text(
          'Anda tidak memiliki akses ke halaman ini',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, color: Colors.pink, fontSize: 18),
        ))),
        SizedBox(
          height: 16,
        ),
        ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, ListKelasPage.id);
            },
            child: Text('List Kelas',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)))
      ],
    );
  }

  Widget verifiedAkses() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 50,
              child: TabBar(
                unselectedLabelColor: Colors.grey,
                labelColor: Colors.pink,
                indicatorColor: Colors.pink,
                labelStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 16),
                unselectedLabelStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.normal, fontSize: 14),
                tabs: [
                  Tab(text: 'Muzamzamah'),
                  Tab(text: 'Al-Falah'),
                  Tab(text: 'An-Amta')
                ],
                controller: _tabController,
              ),
            ),
            Container(
              height: 800,
              child: TabBarView(controller: _tabController, children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 24,
                    ),
                    Text(
                      'Kelas 7',
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          PilihanKelasButton(
                              'Kelas 7A',
                              ['Maths', 'English', 'Computer'],
                              createKelas,
                              'Muzamzamah',
                              userDetail.nama!),
                          PilihanKelasButton(
                              'Kelas 7B',
                              ['Maths', 'English', 'Computer'],
                              createKelas,
                              'Muzamzamah',
                              userDetail.nama!),
                          PilihanKelasButton(
                              'Kelas 7C',
                              ['Maths', 'English', 'Computer'],
                              createKelas,
                              'Muzamzamah',
                              userDetail.nama!),
                          PilihanKelasButton(
                              'Kelas 7D',
                              ['Maths', 'English', 'Computer'],
                              createKelas,
                              'Muzamzamah',
                              userDetail.nama!),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: spaceForKelas,
                    ),
                    Divider(
                      height: 1,
                    ),
                    SizedBox(
                      height: spaceForKelas,
                    ),
                    Text(
                      'Kelas 8',
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          PilihanKelasButton('Kelas 8A', ['Maths', 'English'],
                              createKelas, 'Muzamzamah', userDetail.nama!),
                          PilihanKelasButton('Kelas 8B', ['Maths', 'English'],
                              createKelas, 'Muzamzamah', userDetail.nama!),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: spaceForKelas,
                    ),
                    Divider(
                      height: 1,
                    ),
                    SizedBox(
                      height: spaceForKelas,
                    ),
                    Text(
                      'Kelas 10',
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          PilihanKelasButton('Kelas 10A', ['Computer'],
                              createKelas, 'Muzamzamah', userDetail.nama!),
                          PilihanKelasButton('Kelas 10B', ['Computer'],
                              createKelas, 'Muzamzamah', userDetail.nama!),
                          PilihanKelasButton('Kelas 10C', ['Computer'],
                              createKelas, 'Muzamzamah', userDetail.nama!),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 24,
                    ),
                    Text(
                      'Kelas 7',
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          PilihanKelasButton('Kelas 7A', ['Computer'],
                              createKelas, 'Al-Falah', userDetail.nama!),
                          PilihanKelasButton('Kelas 7B', ['Computer'],
                              createKelas, 'Al-Falah', userDetail.nama!),
                          PilihanKelasButton('Kelas 7C', ['Computer'],
                              createKelas, 'Al-Falah', userDetail.nama!),
                          PilihanKelasButton('Kelas 7D', ['Computer'],
                              createKelas, 'Al-Falah', userDetail.nama!),
                          PilihanKelasButton('Kelas 7E', ['Computer'],
                              createKelas, 'Al-Falah', userDetail.nama!),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: spaceForKelas,
                    ),
                    Divider(
                      height: 1,
                    ),
                    SizedBox(
                      height: spaceForKelas,
                    ),
                    Text(
                      'Kelas 10',
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          PilihanKelasButton('Kelas 10A', ['Computer'],
                              createKelas, 'Al-Falah', userDetail.nama!),
                          PilihanKelasButton('Kelas 10B', ['Computer'],
                              createKelas, 'Al-Falah', userDetail.nama!),
                          PilihanKelasButton('Kelas 10C', ['Computer'],
                              createKelas, 'Al-Falah', userDetail.nama!),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 24,
                    ),
                    Text(
                      'Kelas 7',
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          PilihanKelasButton('Kelas 7A', ['Computer'],
                              createKelas, 'An-Amta', userDetail.nama!),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: spaceForKelas,
                    ),
                    Divider(
                      height: 1,
                    ),
                    SizedBox(
                      height: spaceForKelas,
                    ),
                  ],
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }

  Future<void> getUserDetail() async {
    userDetail = await CurrentUserClass().getUserDetail();
    setState(() {});
    print(userDetail.nama.toString());
  }
}
