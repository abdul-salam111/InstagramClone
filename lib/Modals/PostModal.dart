class PostModal {
  String? postId;
  String? postUrl;
  String? userName;
  String? postDescription;
  String? userProfilePic;
  List? likes = [];
  String? uploadDateAndTime;
  String? userId;
  PostModal(
      {this.postId,
      this.userId,
      this.userName,
      this.postDescription,
      this.postUrl,
      this.userProfilePic,
      this.likes,
      this.uploadDateAndTime});
  factory PostModal.fromJson(Map<String, dynamic> json) {
    return PostModal(
        postId: json["postId"],
        userId: json["userId"],
        userName: json["userName"],
        userProfilePic: json['userProfilePic'],
        postUrl: json["postUrl"],
        likes: json["likes"],
        uploadDateAndTime: json["uploadDateAndTime"],
        postDescription: json["postDescription"]);
  }
  Map<String, dynamic> tojson() {
    return {
      "postId": postId,
      "userId": userId,
      "userName": userName,
      "userProfilePic": userProfilePic,
      "postUrl": postUrl,
      "likes": likes,
      "uploadDateAndTime": uploadDateAndTime,
      "postDescription": postDescription
    };
  }
}
