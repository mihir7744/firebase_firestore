import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Auth_ extends StatefulWidget {

  @override
  State<Auth_> createState() => _Auth_State();
}

class _Auth_State extends State<Auth_> {
  var _height = 40.0;
  var _wight = 390.0;
  var _color = Colors.red;

  bool _users = false;

  final emailcontrolar = TextEditingController();
  final passcontrolar = TextEditingController();
  final conformpass = TextEditingController();

  final fpass_email = TextEditingController();

  Future<void> signin() async {
    try {
      if (passcontrolar.text != "" && emailcontrolar.text != "") {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailcontrolar.text.trim(),
          password: passcontrolar.text.trim(),
        );
      }
    }on FirebaseAuthException catch (e){
      Fluttertoast.showToast(msg: "${e.message}");
    }
  }

  Future signup() async {
    try {
      if (emailcontrolar.text != "" &&
          passcontrolar.text != "" &&
          passcontrolar.text == conformpass.text) {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: emailcontrolar.text.trim(),
          password: passcontrolar.text.trim(),
        );
        //     .then((value) {
        //   FirebaseFirestore.instance
        //       .collection("users")
        //       .doc(FirebaseAuth.instance.currentUser!.uid);
        //   Fluttertoast.showToast(msg: "Successfully Registration");
        // });
      }else if(passcontrolar.text != conformpass.text){
        Fluttertoast.showToast(msg: "Please! enter the same password");
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: "${e.message}");
    }
  }

  // bool pass_() {
  //   if (passcontrolar.text.trim() == conformpass.text.trim()) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  bool _validate = false;

  @override
  void dispose() {
    emailcontrolar.dispose();
    passcontrolar.dispose();
    conformpass.dispose();
    fpass_email.dispose();
    super.dispose();
  }

  Future forgotpass_() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: fpass_email.text.trim())
          .then((value) {
        Fluttertoast.showToast(msg: "Successfully send");
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("User not found!!!"),
            content: Text(e.toString()),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "OK",
                  )),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.android,
                size: 90,
              ),
              SizedBox(
                height: 25,
              ),
              Text(_users == false ? "HELLO AGAIN" : "HELLO FRIENDS",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
              if (_users == false)
                Text("Walcome back, you've been missed! ")
              else
                Text("Walcome, my new app! "),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: TextFormField(
                  controller: emailcontrolar,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.amber),
                          borderRadius: BorderRadius.circular(12)),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Email",
                      errorText:
                          _validate ? 'Please! enter valid email.' : null,
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.red)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.red))),
                ),
              ),
              if (_users == false)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextFormField(
                    controller: passcontrolar,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.amber),
                          borderRadius: BorderRadius.circular(12)),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Password",
                    ),
                  ),
                )
              else
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextFormField(
                        controller: passcontrolar,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.amber),
                              borderRadius: BorderRadius.circular(12)),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Password",
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 25.0, left: 25, right: 25),
                      child: TextFormField(
                        controller: conformpass,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.amber),
                              borderRadius: BorderRadius.circular(12)),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Conform password",
                        ),
                      ),
                    ),
                  ],
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 25.0),
                    child: TextButton(
                        onPressed: forgotpass,
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.amber),
                        )),
                  )
                ],
              ),
              Container(
                height: 55,
                child: GestureDetector(
                  onTap: () {
                    if (_users == true) {
                      signup();
                    } else {
                      signin();
                    }
                    setState(() {
                      emailcontrolar.text.isEmpty
                          ? _validate = true
                          : _validate = false;
                    });
                  },
                  onTapDown: (details) {
                    _height = 40.0;
                    _wight = 90.0;
                    _color == Colors.brown;
                    setState(() {});
                  },
                  onTapUp: (details) {
                    _height = 55.0;
                    _wight = 390.0;
                    _color == Colors.amber;
                    setState(() {});
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 100),
                    height: _height,
                    width: _wight,
                    margin: EdgeInsets.symmetric(horizontal: 25),
                    child: Center(
                        child: Text(
                      _users == true ? "Sign up" : "Log in",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.amber,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 14,
              ),
              GestureDetector(
                  onTap: () {
                    if (_users == true) {
                      _users = false;
                    } else {
                      _users = true;
                    }

                    print(_users);

                    setState(() {});
                  },
                  child: RichText(
                      text: TextSpan(
                          text: "Not a member? ",
                          style: TextStyle(color: Colors.black, fontSize: 15),
                          children: [
                        TextSpan(
                            text:
                                _users == false ? "Register now" : "Login now",
                            style: TextStyle(color: Colors.amber))
                      ])))
            ],
          ),
        ),
      ),
    ));
  }

  void forgotpass() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade300,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text(
                "Enter your email and we will send password reset link",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 25, right: 25),
              child: TextFormField(
                controller: fpass_email,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber),
                      borderRadius: BorderRadius.circular(12)),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Email",
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  forgotpass_();
                  Navigator.pop(context);
                },
                child: Text("Reset"))
          ],
        );
      },
    );
  }
}
