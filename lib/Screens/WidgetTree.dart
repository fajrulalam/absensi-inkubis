import 'package:absensi_inkubis/Screens/ListKelasPage.dart';
import 'package:absensi_inkubis/Screens/LoginPage.dart';
import 'package:flutter/cupertino.dart';

import '../Classes/CurrentUserClass.dart';
import '../Services/Authentication.dart';
import 'DetermineUserRole.dart';
import 'HomePage.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);
  static const String id = 'widget-tree';

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  // Future<CurrentUserObject> userDetail = CurrentUserClass().getUserDetail();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return DetermineUserRole();
          } else {
            return LoginPage();
          }
        });
  }
}
