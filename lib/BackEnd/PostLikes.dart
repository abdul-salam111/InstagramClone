import 'package:cloud_firestore/cloud_firestore.dart';

class Likes {
  Future<void> likePost(String postId, String userId, List likes) async {
    try {
      if (likes.contains(userId)) {
        await FirebaseFirestore.instance
            .collection("posts")
            .doc(postId)
            .update({
          "likes": FieldValue.arrayRemove([userId])
        });
      } else {
        await FirebaseFirestore.instance
            .collection("posts")
            .doc(postId)
            .update({
          "likes": FieldValue.arrayUnion([userId])
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> likeComment(
      String postId, String userId, String commentid, List likes) async {
    try {
      if (likes.contains(userId)) {
        await FirebaseFirestore.instance
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentid)
            .update({
          "likes": FieldValue.arrayRemove([userId])
        });
      } else {
        await FirebaseFirestore.instance
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentid)
            .update({
          "likes": FieldValue.arrayUnion([userId])
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
