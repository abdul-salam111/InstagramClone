class UserStories {
  String? uid;
  String? image;
  String? userName;
  UserStories({this.image, this.uid, this.userName});
  factory UserStories.fromjson(Map<String, dynamic> json) {
    return UserStories(
        uid: json["uid"], image: json["image"], userName: json["userName"]);
  }
  Map<String, dynamic> tojson() {
    return {"uid": uid, "image": image, "userName": userName};
  }
}
