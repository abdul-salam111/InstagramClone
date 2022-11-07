import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instagram_clone/Modals/userModal.dart';

class RegisterUser {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<RegistrationModal> getUserDetails() async {
    User currentUser = firebaseAuth.currentUser!;
    DocumentSnapshot snap =
        await firestore.collection("Users").doc(currentUser.uid).get();
    return RegistrationModal.fromMap(snap.data()! as Map<String, dynamic>);
  }

  Future SignUpUser(String email, String password, String fullName,
      String userName, context, image, filePath) async {
    try {
      await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .whenComplete(() async {
        try {
          if (image != null) {
            Reference reference = FirebaseStorage.instance
                .ref()
                .child("UserProfileImages/$filePath");
            UploadTask uploadTask = reference.putFile(image!);
            uploadTask.then((res) async {
              User? user = firebaseAuth.currentUser;
              RegistrationModal registrationModal = RegistrationModal();
              registrationModal.id = user!.uid;
              registrationModal.email = email;
              registrationModal.bio = "";
              registrationModal.fullName = fullName;
              registrationModal.userName = userName;
              registrationModal.password = password;
              registrationModal.followers = [];
              registrationModal.following = [];
              registrationModal.profilePic = await res.ref.getDownloadURL();
              await firestore
                  .collection("Users")
                  .doc(user.uid)
                  .set(registrationModal.toMap())
                  .then((value) =>
                      Navigator.pushReplacementNamed(context, "HomeScreen"));
            });
          } else {
            User? user = firebaseAuth.currentUser;
            RegistrationModal registrationModal = RegistrationModal();
            registrationModal.id = user!.uid;
            registrationModal.email = email;
            registrationModal.bio = "";
            registrationModal.fullName = fullName;
            registrationModal.userName = userName;
            registrationModal.followers = [];

            registrationModal.following = [];
            registrationModal.password = password;
            await firestore
                .collection("Users")
                .doc(user.uid)
                .set(registrationModal.toMap())
                .then((value) =>
                    Navigator.pushReplacementNamed(context, "HomeScreen"));
          }
        } on FirebaseAuthException catch (e) {
          Fluttertoast.showToast(
              msg: e.message!,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP);
        }
      }).then((value) {});
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
          msg: e.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM);
    }
  }
}
