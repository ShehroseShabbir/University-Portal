import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Setup/signIn.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
            value: FirebaseAuth.instance.onAuthStateChanged)
      ],
      child: MaterialApp(
        theme: new ThemeData(
          primarySwatch: Colors.yellow,
        ),
        home: Scaffold(
          body: LoginPage(),
        ),
      ),
    );
  }
}
