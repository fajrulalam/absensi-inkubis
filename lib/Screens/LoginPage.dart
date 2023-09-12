import 'package:absensi_inkubis/Screens/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Services/Authentication.dart';

class LoginPage extends StatefulWidget {
  static String id = 'login-page';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String test = 'test';

  TextEditingController emailController_login = TextEditingController();
  TextEditingController passwordController_login = TextEditingController();

  TextEditingController emailController_register = TextEditingController();
  TextEditingController passwordController_register = TextEditingController();
  TextEditingController nama_register = TextEditingController();

  String userInterface = 'login';

  String jenisKelamin_register = '';
  String asrama_register = '';
  String jenisAkun_register = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login Kelas Inkubis',
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.pink),
        ),
        centerTitle: false,
      ),
      body: userInterface == 'login' ? LoginInterface() : RegisterInterface(),
    );
  }

  Widget RegisterInterface() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
          ),
          Center(
            child: Card(
                elevation: 4,
                child: Column(
                  children: [
                    Container(
                        constraints: BoxConstraints(minWidth: 400),
                        height: MediaQuery.of(context).size.height / 4.5,
                        width: MediaQuery.of(context).size.width / 2,
                        child: Image.asset('assets/welcome.png',
                            fit: BoxFit.fitWidth)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Selamat Datang di Absensi Inkubis',
                        style: GoogleFonts.poppins(
                            color: Colors.pink, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )),
          ),
          Center(
            child: Card(
              elevation: 4,
              child: Container(
                constraints: BoxConstraints(minWidth: 400),
                width: MediaQuery.of(context).size.width / 2,
                child: Column(children: [
                  SizedBox(
                    height: 16,
                  ),
                  //username and password field
                  Container(
                    padding: EdgeInsets.all(8),
                    child: TextField(
                      controller: emailController_register,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          hintText: 'Masukkan email'),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    child: TextField(
                      controller: nama_register,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nama',
                          hintText: 'Masukkan nama lengkap'),
                    ),
                  ),
                  //dropdown with option Jenis Kelamin Laki-Laki or Perempuan
                  Container(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Jenis kelamin',
                                  hintText: 'Pilih jenis kelamin'),
                              items: <DropdownMenuItem>[
                                DropdownMenuItem(
                                  child: Text('Laki-Laki'),
                                  value: 'Laki-Laki',
                                ),
                                DropdownMenuItem(
                                  child: Text('Perempuan'),
                                  value: 'Perempuan',
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  jenisKelamin_register = value.toString();
                                  print('jenis kelamin: ' +
                                      jenisKelamin_register);
                                });
                              }),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Asrama',
                                  hintText: 'Pilih asramamu'),
                              items: <DropdownMenuItem>[
                                DropdownMenuItem(
                                  child: Text('Muzamzamah'),
                                  value: 'Muzamzamah',
                                ),
                                DropdownMenuItem(
                                  child: Text('Al-Falah'),
                                  value: 'Al-Falah',
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  asrama_register = value.toString();
                                  print(asrama_register);
                                });
                              }),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    child: DropdownButtonFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Jenis akun',
                            hintText: 'Pilih jenis akun'),
                        items: <DropdownMenuItem>[
                          DropdownMenuItem(
                            child: Text('Tutor'),
                            value: 'Tutor',
                          ),
                          DropdownMenuItem(
                            child: Text('Siswa'),
                            value: 'Siswa',
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            jenisAkun_register = value.toString();
                            print(jenisAkun_register);
                          });
                        }),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    child: TextField(
                      obscureText: true,
                      controller: passwordController_register,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          hintText: 'Masukkan password'),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        registerWithEmailAndPassword();
                      },
                      child: Text(
                        'Buat Akun',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      )),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Sudah punya akun?', style: GoogleFonts.poppins()),
                      TextButton(
                          onPressed: () {
                            userInterface = 'login';
                            setState(() {});
                          },
                          child: Text('Masuk',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold))),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget LoginInterface() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 50,
        ),
        Center(
          child: Card(
              elevation: 4,
              child: Column(
                children: [
                  Container(
                      constraints: BoxConstraints(minWidth: 400),
                      height: MediaQuery.of(context).size.height / 4.5,
                      width: MediaQuery.of(context).size.width / 2,
                      child: Image.asset('assets/welcome.png',
                          fit: BoxFit.fitWidth)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Selamat Datang di Absensi Inkubis',
                      style: GoogleFonts.poppins(
                          color: Colors.pink, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )),
        ),
        Center(
          child: Card(
            elevation: 4,
            child: Container(
              constraints: BoxConstraints(minWidth: 400),
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width / 2,
              child: Column(children: [
                Spacer(),
                //username and password field
                Container(
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    controller: emailController_login,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        hintText: 'Masukkan email'),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    controller: passwordController_login,
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        hintText: 'Masukkan password'),
                  ),
                ),
                Spacer(),
                ElevatedButton(
                    onPressed: () {
                      signInWithEmailAndPassword();
                    },
                    child: Text(
                      'Login',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    )),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Belum punya akun?', style: GoogleFonts.poppins()),
                    TextButton(
                        onPressed: () {
                          userInterface = 'register';
                          setState(() {});
                        },
                        child: Text('Buat Akun',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold))),
                  ],
                ),
                Spacer(),
              ]),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: emailController_login.text.trim(),
          password: passwordController_login.text);
      // Navigator.pushReplacementNamed(context, WidgetTree.id);
    } catch (e) {
      //show scaffold for 2 seconds that password or email is wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email atau password salah'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> registerWithEmailAndPassword() async {
    //check if all the attributes are filled
    if (nama_register.text.trim() == '' ||
        emailController_register.text.trim() == '' ||
        passwordController_register.text == '' ||
        asrama_register == '' ||
        jenisAkun_register == '' ||
        jenisKelamin_register == '') {
      //print all the attributes so i know which one is empty
      print(nama_register.text.trim());
      print(emailController_register.text.trim());
      print(passwordController_register.text);
      print(asrama_register);
      print(jenisAkun_register);
      print(jenisKelamin_register);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Isi semua atribut terlebih dahulu'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      await Auth().createUserWithEmailAndPssword(
        email: emailController_register.text.trim(),
        password: passwordController_register.text,
        asrama: asrama_register,
        jenisAkun: jenisAkun_register,
        jenisKelamin: jenisKelamin_register,
        nama: nama_register.text.trim(),
      );
      // Navigator.pushReplacementNamed(context, WidgetTree.id);
    } catch (e) {
      //show scaffold for 2 seconds that password or email is wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Coba lagi'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
