import 'package:cloud_firestore/cloud_firestore.dart';

class CommentsModal {
  String? id;
  String? commenterProfile;
  String? commentText;
  List? likes;
  String? commentTime;
  String? commenterName;
  String? postId;
  CommentsModal({
    this.id,
    this.commentText,
    this.commentTime,
    this.commenterName,
    this.commenterProfile,
    this.likes,
    this.postId,
  });
  factory CommentsModal.fromJson(Map<String, dynamic> json) {
    return CommentsModal(
        id: json['id'],
        postId: json['postId'],
        commenterProfile: json['commenterProfile'],
        commentText: json['commentText'],
        likes: json['likes'],
        commentTime: json['commentTime'],
        commenterName: json['commenterName']);
  }
  Map<String, dynamic> tojson() {
    return {
      'id': id,
      "commenterProfile": commenterProfile,
      "postId": postId,
      "commentText": commentText,
      "likes": likes,
      "commentTime": commentTime,
      "commenterName": commenterName
    };
  }
}
