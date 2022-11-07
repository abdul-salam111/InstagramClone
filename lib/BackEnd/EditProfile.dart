import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Modals/userModal.dart';
import 'package:instagram_clone/Screens/ProfileScreen.dart';

class EditProfileBackend {
  Future editMyProfile(
      filePath, image, bio, userName, fullName, context) async {
    if (image != null) {
      Reference reference =
          FirebaseStorage.instance.ref().child("UserProfileImages/$filePath");
      UploadTask uploadTask = reference.putFile(image!);
      uploadTask.then((res) async {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          "profilePic": await res.ref.getDownloadURL(),
          "fullName": fullName,
          "userName": userName,
          "bio": bio
        }).then((value) =>
                Navigator.pushReplacementNamed(context, "HomeScreen"));
      });
    } else {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "fullName": fullName,
        "userName": userName,
        "bio": bio
      }).then((value) => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (builder) => MyAccount())));
    }
  }
}
