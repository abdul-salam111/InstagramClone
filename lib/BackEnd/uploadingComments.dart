import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/Modals/commentsModal.dart';
import 'package:uuid/uuid.dart';

class UploadComments {
  void postComments(
      {String? commentText,
      String? commenterName,
      String? commenterProfile,
      String? postId,
      String? commentTime}) async {
    try {
      final firebaseAuth = FirebaseAuth.instance;
      final firestore = FirebaseFirestore.instance;
      String commentId = Uuid().v4();
      CommentsModal commentsModal = CommentsModal(
          id: commentId,
          likes: [],
          commentText: commentText,
          postId: postId,
          commentTime: commentTime,
          commenterName: commenterName,
          commenterProfile: commenterProfile);
      await firestore
          .collection("posts")
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .set(commentsModal.tojson())
          .then((value) => {print(true)});
    } catch (e) {
      print(e);
    }
  }
}
