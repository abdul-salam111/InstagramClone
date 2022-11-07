import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Modals/PostModal.dart';
import 'package:uuid/uuid.dart';

class UploadPosts {
  final firebaseAuth = FirebaseAuth.instance;
  final firebasefirestore = FirebaseFirestore.instance;
  Future<String> uploadImage(image, filePath) async {
    if (image != null) {
      Reference reference = FirebaseStorage.instance
          .ref()
          .child("posts/")
          .child(firebaseAuth.currentUser!.uid)
          .child('$filePath');
      UploadTask uploadTask = reference.putFile(image!);
      return uploadTask.then((post) => post.ref.getDownloadURL());
    }
    return "sorry";
  }

  uploadPost(String userName, String postDescription, String userId,
      String userProfilePic, image, filePath, context) async {
    try {
      String postUrl = await uploadImage(image, filePath);
      String postId = Uuid().v4();
      PostModal postModal = PostModal(
          postId: postId,
          userName: userName,
          postDescription: postDescription,
          userId: userId,
          uploadDateAndTime: DateTime.now().toString(),
          likes: [],
          userProfilePic: userProfilePic,
          postUrl: postUrl);
      await firebasefirestore
          .collection("posts")
          .doc(postId)
          .set(postModal.tojson())
          .then((value) {
        var snakbar = const SnackBar(
          content: Text("Post uploaded"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snakbar);
      });
    } catch (e) {
      print(e);
    }
  }
}
