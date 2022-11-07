import 'package:cloud_firestore/cloud_firestore.dart';

class FollowUser {
  Future<void> followUsers(String uId, String followingId) async {
    try {
      DocumentSnapshot documentSnapshot =
          await FirebaseFirestore.instance.collection("Users").doc(uId).get();
      List following = ((documentSnapshot.data() as dynamic)["following"]);
      if (following.contains(followingId)) {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(followingId)
            .update({
          "followers": FieldValue.arrayRemove([uId])
        });
        await FirebaseFirestore.instance.collection("Users").doc(uId).update({
          "following": FieldValue.arrayRemove([followingId])
        });
      } else {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(followingId)
            .update({
          "followers": FieldValue.arrayUnion([uId])
        });
        await FirebaseFirestore.instance.collection("Users").doc(uId).update({
          "following": FieldValue.arrayUnion([followingId])
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
