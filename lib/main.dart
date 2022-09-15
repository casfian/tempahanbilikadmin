import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tempahanbilikadmin/authenticate.dart';
import 'package:tempahanbilikadmin/authentication.dart';
import 'package:tempahanbilikadmin/home.dart';

//utk Authenticate
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
        Provider<AuthenticationProvider>(
          create: (_) => AuthenticationProvider(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationProvider>().authState,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App', 
        home: Authenticate(returnClass: const Home(),),
        ),
    );
  }
}
