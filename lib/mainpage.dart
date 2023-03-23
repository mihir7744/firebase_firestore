import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_firestore/Auth_.dart';
import 'package:firebase_firestore/notes.dart';
import 'package:flutter/material.dart';

class Mainpage extends StatelessWidget {
  const Mainpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Notes();
          } else {
            return Auth_();
          }
        },
      ),
    );
  }
}
