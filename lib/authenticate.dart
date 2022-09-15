import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tempahanbilikadmin/login.dart';


//class ne utk check dia dah login atau tak
class Authenticate extends StatelessWidget {
  Authenticate({super.key, required this.returnClass});

  dynamic returnClass;

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    // kalau user ada (user bukan kosong aka null) maka maksudnya dah login
    if (firebaseUser != null) {
      return returnClass; //dan kita suruh dia gi page Home
    }
    // kalau tak suruh dia login
    return Login();
  }
}
