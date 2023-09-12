import 'package:absensi_inkubis/Screens/BukaKelasPage.dart';
import 'package:absensi_inkubis/Screens/HomePage.dart';
import 'package:absensi_inkubis/Screens/ListKelasPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'Screens/WidgetTree.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // name: 'e-santren',
      options: FirebaseOptions(
          apiKey: "AIzaSyBVTQPD1wxkk5LoplBejmRR0Lmb9wgghcM",
          appId: "1:513743155198:web:77647e5dd28c5ef7e3daaf'",
          messagingSenderId: "513743155198",
          storageBucket: 'nkubis-fe474.appspot.com',
          projectId: "inkubis-fe474"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: [Locale('id'), Locale('en', 'UK')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: ThemeData.light().copyWith(
          colorScheme: ThemeData().colorScheme.copyWith(primary: Colors.pink),
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 1,
              titleTextStyle: TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.w500,
                  fontSize: 18))),
      initialRoute: WidgetTree.id,
      locale: Locale('id'),
      routes: {
        WidgetTree.id: (context) => WidgetTree(),
        HomePage.id: (context) => HomePage(),
        ListKelasPage.id: (context) => ListKelasPage(),
        BukaKelasPage.id: (context) => BukaKelasPage(
              documentId:
                  ModalRoute.of(context)?.settings.arguments as String? ??
                      'default',
            ),
      },
    );
  }
}

class T extends StatelessWidget {
  const T({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
