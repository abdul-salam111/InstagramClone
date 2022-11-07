import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram_clone/Screens/InstaStories.dart';
import 'package:instagram_clone/Screens/createStories.dart';
import 'package:instagram_clone/Utils/Post_Card.dart';
import 'package:instagram_clone/Utils/colors.dart';
import 'package:instagram_clone/providers/userProvider.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  static String collectionDbName = 'stories';
  CollectionReference dbInstance =
      FirebaseFirestore.instance.collection(collectionDbName);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<userProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        leadingWidth: 170,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            "images/logo.png",
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                FontAwesomeIcons.facebookMessenger,
                color: Colors.black,
              ))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Column(
                  children: [
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => CreateStories()));
                          },
                          child: ClipOval(
                            child: user.profilePic != null
                                ? CachedNetworkImage(
                                    height: 70,
                                    width: 70,
                                    fit: BoxFit.cover,
                                    imageUrl: user.profilePic.toString(),
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  )
                                : Center(
                                    child: CircularProgressIndicator(),
                                  ),
                          ),
                        ),
                        Positioned(
                            bottom: 2,
                            right: 2,
                            child: Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  border: Border.all(width: 2),
                                  borderRadius: BorderRadius.circular(50)),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 13,
                              ),
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "Your story",
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    )
                  ],
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("stories")
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
                      if (snapshots.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: snapshots.data!.docs.length,
                            itemBuilder: (context, index) {
                              return CircleAvatar(
                                backgroundImage: NetworkImage(
                                    snapshots.data!.docs[index]["image"]),
                              );
                            });
                      }
                    },
                  ),
                )
              ],
            ),
          ),
          const Divider(
            height: 2,
          ),
          Expanded(
              child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("posts")
                .orderBy("uploadDateAndTime", descending: true)
                .snapshots(),
            builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: ((context, index) {
                      return PostCard(
                        userName: snapshot.data!.docs[index]["userName"],
                        userProfile: snapshot.data!.docs[index]
                            ["userProfilePic"],
                        likes: snapshot.data!.docs[index]["likes"] as List,
                        postimageUrl: snapshot.data!.docs[index]["postUrl"],
                        description: snapshot.data!.docs[index]
                            ["postDescription"],
                        dateTime: snapshot.data!.docs[index]
                            ["uploadDateAndTime"],
                        postId: snapshot.data!.docs[index].id,
                      );
                    }));
              }
            }),
          ))
        ],
      ),
    );
  }
}
