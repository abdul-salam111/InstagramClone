import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/BackEnd/uploadingComments.dart';
import 'package:instagram_clone/Utils/CommentsCard.dart';
import 'package:instagram_clone/providers/userProvider.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  String? postId;
  String? description;
  String? userProfile;
  CommentScreen({Key? key, this.postId, this.description, this.userProfile})
      : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final commentController = TextEditingController();
  UploadComments uploadComments = UploadComments();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<userProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Comments",
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Row(
                children: [
                  ClipOval(
                    child: CachedNetworkImage(
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                      imageUrl: widget.userProfile.toString(),
                      placeholder: (context, url) =>
                          new CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          new Icon(Icons.error),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Flexible(child: Text(widget.description.toString())),
                ],
              ),
            ),
          ),
          const Divider(),
          Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("posts")
                      .doc(widget.postId)
                      .collection("comments")
                      .orderBy("commentTime", descending: false)
                      .snapshots(),
                  builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: const CircularProgressIndicator());
                    } else {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: ((context, index) {
                            return CommentsCard(
                              commenterProfile: snapshot.data!.docs[index]
                                  ["commenterProfile"],
                              commenterName: snapshot.data!.docs[index]
                                  ["commenterName"],
                              comment: snapshot.data!.docs[index]
                                  ["commentText"],
                              commenTime: snapshot
                                  .data!.docs[index]["commentTime"]
                                  .toString(),
                              likes: snapshot.data!.docs[index]["likes"],
                              postId: snapshot.data!.docs[index]["postId"],
                              commentId: snapshot.data!.docs[index].id,
                            );
                          }));
                    }
                  }))),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                    imageUrl: user.profilePic.toString(),
                    placeholder: (context, url) =>
                        new CircularProgressIndicator(),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: "Add a comment..."),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      uploadComments.postComments(
                          commentText: commentController.text.trim(),
                          commentTime: (DateTime.now().toString()),
                          commenterName: user.userName,
                          commenterProfile: user.profilePic.toString(),
                          postId: widget.postId);
                      commentController.clear();
                    },
                    child: Text(
                      "Post",
                      style: TextStyle(
                          color: Colors.grey[700], fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
