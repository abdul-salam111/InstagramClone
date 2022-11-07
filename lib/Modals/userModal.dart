class RegistrationModal {
  String? id;
  String? userName;
  String? fullName;
  String? email;
  String? password;
  String? bio;
  String? profilePic;
  List? followers = [];
  List? following = [];

  RegistrationModal(
      {this.id,
      this.fullName,
      this.userName,
      this.email,
      this.password,
      this.profilePic,
      this.bio,
      this.followers,
      this.following});
  factory RegistrationModal.fromMap(Map<String, dynamic> json) {
    return RegistrationModal(
        id: json['id'],
        userName: json["userName"],
        fullName: json["fullName"],
        email: json['email'],
        bio: json["bio"],
        password: json['password'],
        profilePic: json["profilePic"],
        followers: json['followers'],
        following: json["following"]);
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
      'fullName': fullName,
      'email': email,
      'bio': bio,
      'password': password,
      'profilePic': profilePic,
      "status": "online",
      "following": followers,
      "followers": following
    };
  }
}
