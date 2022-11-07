import 'package:cloud_firestore/cloud_firestore.dart';

class DeletePost {
  Future deletePost(String id) async {
    try {
      FirebaseFirestore.instance
          .collection("posts")
          .doc(id)
          .delete()
          .then((value) {
        print("Post deleted");
      });
    } catch (e) {
      print(e);
    }
  }
}
