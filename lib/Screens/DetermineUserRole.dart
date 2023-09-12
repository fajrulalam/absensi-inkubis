import 'package:absensi_inkubis/Screens/HomePage.dart';
import 'package:absensi_inkubis/Screens/ListKelasPage.dart';
import 'package:flutter/cupertino.dart';

import '../Classes/CurrentUserClass.dart';

class DetermineUserRole extends StatefulWidget {
  const DetermineUserRole({super.key});

  @override
  State<DetermineUserRole> createState() => _DetermineUserRoleState();
}

class _DetermineUserRoleState extends State<DetermineUserRole> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListKelasPage();
  }
}
