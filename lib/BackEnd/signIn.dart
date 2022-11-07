import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SigningInUser {
  FirebaseAuth firebase = FirebaseAuth.instance;
  Future userSigin(String email, String password, context) async {
    try {
      await firebase
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        Fluttertoast.showToast(msg: "Logged in Successfully!");
      }).then((value) {
        Navigator.pushReplacementNamed(context, "HomeScreen");
      });
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
          msg: e.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP);
    }
  }
}
