import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instagram_clone/Screens/HomeScreen.dart';
import 'package:instagram_clone/Screens/loginScreen.dart';

class AuthServices {
  handleState() {
    try {
      return StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("something went wrong"),
              );
            } else if (snapshot.hasData) {
              return const HomeScreen();
            } else {
              return const SignInUser();
            }
          });
    } on PlatformException catch (e) {
      Fluttertoast.showToast(msg: e.message!);
    }
  }
  googleSignOut(context) async {
    try {
      await FirebaseAuth.instance.signOut().then((value) {
        Fluttertoast.showToast(msg: "SignOut", toastLength: Toast.LENGTH_SHORT)
            .then((value) {
          Navigator.pushReplacementNamed(context, "SignIn");
        });
      });
    } on PlatformException catch (e) {
      Fluttertoast.showToast(msg: e.message!, toastLength: Toast.LENGTH_LONG);
    }
  }
}
