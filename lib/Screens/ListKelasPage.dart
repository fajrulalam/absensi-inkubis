import 'package:absensi_inkubis/Screens/BukaKelasPage.dart';
import 'package:absensi_inkubis/Screens/HomePage.dart';
import 'package:absensi_inkubis/Screens/LoginPage.dart';
import 'package:absensi_inkubis/Screens/WidgetTree.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../Classes/CurrentUserClass.dart';
import '../Classes/ListKelasClass.dart';
import '../Services/Authentication.dart';

class ListKelasPage extends StatefulWidget {
  static const String id = 'list-kelas-page';

  const ListKelasPage({super.key});

  @override
  State<ListKelasPage> createState() => _ListKelasPageState();
}

class _ListKelasPageState extends State<ListKelasPage> {
  List<Kelas> listKelasYangMasihBuka = [];
  List<Kelas> listKelasYangSelesai = [];
  CurrentUserObject userDetail = CurrentUserObject(role: 'kosong');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getKelasYangBelumSelesai();
    getKelasYangSudahSelesai();
    getUserDetail();
  }

  Future<void> getUserDetail() async {
    userDetail = await CurrentUserClass().getUserDetail();
    setState(() {});
    print(userDetail.role.toString());
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
            Text("List Kelas yang Buka",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(
              width: 16,
            ),
            if (userDetail.role != 'Siswa')
              Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, HomePage.id);
                      },
                      child: Text(
                        'Buka Kelas',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                      )))
          ],
        ),
        centerTitle: false,
        actions: [
          Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: OutlinedButton(
                  onPressed: () {
                    Auth().signOut();
                    Navigator.popUntil(
                        context, ModalRoute.withName(WidgetTree.id));
                  },
                  child: Text(
                    'Logout',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  )))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: userDetail.role != 'Admin' ? userIsNotAdmin() : userIsAdmin(),
      ),
    );
  }

  Widget userIsNotAdmin() {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 600),
        child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Card(
                  child: ListTile(
                    onTap: () {
                      if (userDetail.role == 'kosong')
                        return;
                      else if ((userDetail.role == 'Tutor' ||
                              userDetail.role == 'Admin') &&
                          userDetail.isVerified == true)
                        Navigator.pushNamed(context, BukaKelasPage.id,
                            arguments: listKelasYangMasihBuka[index].id);
                      else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return InsertKodeKelas(
                                documentID: listKelasYangMasihBuka[index].id,
                                userDetail: userDetail,
                                kodeKelas:
                                    listKelasYangMasihBuka[index].kodeKelas,
                              );
                            });
                      }
                    },
                    title: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        '${listKelasYangMasihBuka[index].kelas} - ${listKelasYangMasihBuka[index].mataPelajaran}',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        formatDate(listKelasYangMasihBuka[index].waktuMulai),
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                    trailing: Text(
                      listKelasYangMasihBuka[index].asrama,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600, color: Colors.black54),
                    ),
                  ),
                ),
              );
            },
            itemCount: listKelasYangMasihBuka.length),
      ),
    );
  }

  Widget userIsAdmin() {
    return DefaultTabController(
      length: 2,
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
                Tab(
                  text: 'Kelas Aktif',
                ),
                Tab(
                  text: 'Kelas Selesai',
                )
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 200,
            child: TabBarView(children: [
              if (listKelasYangMasihBuka.length == 0)
                Container(
                  child: Center(
                    child: Text(
                      'Tidak ada kelas yang sedang berlangsung',
                      style: GoogleFonts.poppins(
                          color: Colors.black54, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              else
                ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Card(
                          child: ListTile(
                            onTap: () {
                              if (userDetail.role == 'kosong')
                                return;
                              else if ((userDetail.role == 'Tutor' ||
                                      userDetail.role == 'Admin') &&
                                  userDetail.isVerified == true)
                                Navigator.pushNamed(context, BukaKelasPage.id,
                                    arguments:
                                        listKelasYangMasihBuka[index].id);
                              else {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return InsertKodeKelas(
                                        documentID:
                                            listKelasYangMasihBuka[index].id,
                                        userDetail: userDetail,
                                        kodeKelas: listKelasYangMasihBuka[index]
                                            .kodeKelas,
                                      );
                                    });
                              }
                            },
                            title: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                '${listKelasYangMasihBuka[index].kelas} - ${listKelasYangMasihBuka[index].mataPelajaran}',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            subtitle: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                formatDate(
                                    listKelasYangMasihBuka[index].waktuMulai),
                                style: GoogleFonts.poppins(),
                              ),
                            ),
                            trailing: Text(
                              listKelasYangMasihBuka[index].asrama,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: listKelasYangMasihBuka.length),
              ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Card(
                        child: ListTile(
                          onTap: () {
                            if (userDetail.role == 'kosong')
                              return;
                            else if ((userDetail.role == 'Tutor' ||
                                    userDetail.role == 'Admin') &&
                                userDetail.isVerified == true)
                              Navigator.pushNamed(context, BukaKelasPage.id,
                                  arguments: listKelasYangSelesai[index].id);
                            else {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return InsertKodeKelas(
                                      documentID:
                                          listKelasYangSelesai[index].id,
                                      userDetail: userDetail,
                                      kodeKelas:
                                          listKelasYangSelesai[index].kodeKelas,
                                    );
                                  });
                            }
                          },
                          title: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Container(
                              width: 600,
                              child: Row(
                                children: [
                                  Text(
                                    '${listKelasYangSelesai[index].kelas} - ${listKelasYangSelesai[index].mataPelajaran}',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              formatDate(
                                  listKelasYangSelesai[index].waktuMulai),
                              style: GoogleFonts.poppins(),
                            ),
                          ),
                          trailing: Column(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      //add curve
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.pink.withOpacity(0.8)),
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 4),
                                      child: Text(
                                        listKelasYangSelesai[index]
                                            .jumlahHadir
                                            .toString(),
                                        style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ))),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                listKelasYangSelesai[index].asrama,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: listKelasYangSelesai.length),
            ]),
          )
        ],
      ),
    );
  }

  String formatDate(DateTime waktuMulai) {
    //format datetime in the format of EEEE, dd MMMM yyyy HH:mm with indonesia localization
    var formattedDate =
        DateFormat('EEEE, dd MMM yyyy HH:mm', 'id').format(waktuMulai);

    return formattedDate;
  }

  Future<void> getKelasYangBelumSelesai() async {
    FirebaseFirestore.instance
        .collection('AbsenKelasCollection')
        .where('waktuSelesai', isGreaterThan: Timestamp.now())
        .get()
        .then((value) {
      setState(() {
        listKelasYangMasihBuka = KelasClass.getKelasAktif(value);
        print(listKelasYangMasihBuka.length);
      });
    });
  }

  Future<void> getKelasYangSudahSelesai() async {
    FirebaseFirestore.instance
        .collection('AbsenKelasCollection')
        .where('waktuSelesai', isLessThan: Timestamp.now())
        .orderBy('waktuSelesai', descending: true)
        .get()
        .then((value) {
      setState(() {
        listKelasYangSelesai = KelasClass.getKelasAktif(value);
        print(listKelasYangSelesai.length);
      });
    });
  }
}

class InsertKodeKelas extends StatefulWidget {
  final String documentID;
  final String kodeKelas;
  final CurrentUserObject userDetail;

  const InsertKodeKelas(
      {super.key,
      required this.documentID,
      required this.userDetail,
      required this.kodeKelas});

  @override
  State<InsertKodeKelas> createState() => _InsertKodeKelasState();
}

class _InsertKodeKelasState extends State<InsertKodeKelas> {
  bool clickable = false;
  TextEditingController kodeKelasController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Masukkan Kode Kelas',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, color: Colors.pink),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                margin: EdgeInsets.only(bottom: 16, right: 16, left: 16),
                child: TextField(
                  controller: kodeKelasController,
                  //only numbers
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6)
                  ],
                  onChanged: (value) {
                    if (value.length == 6)
                      clickable = true;
                    else
                      clickable = false;
                    setState(() {});
                  },

                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Kode Kelas'),
                ),
              ),
              Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                        margin: EdgeInsets.only(right: 16),
                        child: ElevatedButton(
                            onPressed: clickable
                                ? () {
                                    print('FOTO:' + widget.userDetail.foto!);
                                    if (kodeKelasController.text !=
                                        widget.kodeKelas) {
                                      //show red snackbar informing the user that kode kelas salah
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            'Kode Kelas Salah, Silahkan Coba Lagi'),
                                        duration: Duration(seconds: 2),
                                        backgroundColor: Colors.red,
                                      ));
                                      return;
                                    }
                                    FirebaseFirestore.instance
                                        .collection('AbsenKelasCollection')
                                        .doc(widget.documentID)
                                        .collection('SiswaHadirCollection')
                                        .doc(widget.userDetail.uid)
                                        .set({
                                      'nama': widget.userDetail.nama,
                                      'foto': widget.userDetail.foto,
                                      'jenisKelamin':
                                          widget.userDetail.jenisKelamin,
                                      'userID': widget.userDetail.uid,
                                      'timestampMasuk': Timestamp.now(),
                                      'jumlahHadir': FieldValue.increment(1)
                                    }).then((value) => Navigator.pushNamed(
                                            context, BukaKelasPage.id,
                                            arguments: widget.documentID));
                                  }
                                : null,
                            child: Text('Masuk')))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
