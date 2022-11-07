import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/BackEnd/AuthState.dart';
import 'package:instagram_clone/BackEnd/followUsers.dart';
import 'package:instagram_clone/Screens/EditProfile.dart';
import 'package:instagram_clone/Utils/colors.dart';
import 'package:instagram_clone/Utils/followButton.dart';
import 'package:ionicons/ionicons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MyAccount extends StatefulWidget {
  String? uid;
  MyAccount({Key? key, this.uid}) : super(key: key);

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  int? totalPosts;
  List? followers = [], following = [];
  String? userName, profilePic, bio;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    var usersnap = await FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.uid)
        .get();
    var postsnap = await FirebaseFirestore.instance
        .collection("posts")
        .where("userId", isEqualTo: widget.uid)
        .get();
    totalPosts = postsnap.docs.length;
    followers = await usersnap.data()!["followers"];
    following = await usersnap.data()!["following"];
    userName = await usersnap.data()!["userName"];
    profilePic = await usersnap.data()!["profilePic"];
    bio = await usersnap.data()!["bio"];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: false,
        title: GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              const Icon(
                Icons.lock_outline,
                color: Colors.black,
                size: 15,
              ),
              Text(
                userName ?? "",
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Container(
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(5)),
                child: const Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 17,
                ),
              )),
          IconButton(
              onPressed: () {
                showMaterialModalBottomSheet(
                    context: context,
                    builder: (context) => SingleChildScrollView(
                        controller: ModalScrollController.of(context),
                        child: Container(
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            child: Column(
                              children: [
                                const Center(
                                    child: Divider(
                                  indent: 160,
                                  endIndent: 160,
                                  thickness: 5,
                                )),
                                ListView(
                                  keyboardDismissBehavior:
                                      ScrollViewKeyboardDismissBehavior.onDrag,
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  children: [
                                    ListTile(
                                      leading: Icon(Ionicons.settings),
                                      title: Text("Settings"),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.local_activity),
                                      title: Text("Your Activity"),
                                    ),
                                    ListTile(
                                      leading: Icon(Ionicons.save),
                                      title: Text("Saved"),
                                    ),
                                    ListTile(
                                      onTap: () {},
                                      leading: Icon(Icons.favorite),
                                      title: Text("Favorites"),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.qr_code),
                                      title: Text("QR code"),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.logout),
                                      title: Text("Logout"),
                                      onTap: () {
                                        AuthServices().googleSignOut(context);
                                      },
                                    )
                                  ],
                                ),
                              ],
                            ))));
              },
              icon: const Icon(
                Icons.more_horiz,
                color: Colors.black,
              )),
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipOval(
                      child: profilePic != null
                          ? CachedNetworkImage(
                              height: 70,
                              width: 70,
                              fit: BoxFit.cover,
                              imageUrl: profilePic!,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            )
                          : Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${totalPosts ?? ""}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Posts",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${followers!.length}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Followers",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${following!.length}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Following",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      bio ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    FirebaseAuth.instance.currentUser!.uid == widget.uid
                        ? FollowButton(
                            buttonName: "Edit Profile",
                            ontap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => EditProfile()));
                            },
                            btncolor: Colors.blue,
                          )
                        : FollowButton(
                            buttonName: followers!.contains(
                                    FirebaseAuth.instance.currentUser!.uid)
                                ? "Unfollow"
                                : "Follow",
                            btncolor: followers!.contains(
                                    FirebaseAuth.instance.currentUser!.uid)
                                ? Colors.black
                                : Colors.blue,
                            ontap: () async {
                              await FollowUser().followUsers(
                                  FirebaseAuth.instance.currentUser!.uid,
                                  widget.uid!);
                            },
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Story highlights",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text("Keep your favorite stories on your profile"),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 14,
                    ),
                  ],
                ),
              ),
              const TabBar(
                tabs: [
                  Tab(
                      icon: Icon(
                    Icons.grid_view,
                    color: Colors.black,
                  )),
                  Tab(
                      icon: Icon(
                    Icons.personal_video,
                    color: Colors.black,
                  )),
                  Tab(
                      icon: Icon(
                    Icons.person_outline_rounded,
                    color: Colors.black,
                  )),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 1.3,
                child: TabBarView(children: [
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("posts")
                          .where("userId", isEqualTo: widget.uid)
                          .snapshots(),
                      builder:
                          ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return GridView.builder(
                              scrollDirection: Axis.vertical,
                              physics: const BouncingScrollPhysics(),
                              itemCount: snapshot.data!.docs.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                              ),
                              itemBuilder: ((context, index) {
                                return CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: snapshot.data!.docs[index]
                                      ["postUrl"],
                                  placeholder: (context, url) => const Center(
                                      child: const CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                );
                              }));
                        }
                      })),
                  const Text("Videos"),
                  const Text("Tags")
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
