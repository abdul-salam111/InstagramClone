import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:insta_like_button/insta_like_button.dart';
import 'package:instagram_clone/BackEnd/PostLikes.dart';
import 'package:instagram_clone/BackEnd/deletePost.dart';
import 'package:instagram_clone/Screens/commentsScreen.dart';
import 'package:instagram_clone/Screens/postEditScreen.dart';
import 'package:instagram_clone/providers/userProvider.dart';

import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  String? description;
  String? postimageUrl;
  String? userName;
  List? likes;
  String? userProfile;
  String? dateTime;
  String? postId;
  PostCard(
      {this.postimageUrl,
      this.likes,
      this.userName,
      this.userProfile,
      this.description,
      this.dateTime,
      this.postId});
  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  Likes likes = Likes();
  DeletePost deletePost = DeletePost();

  @override
  Widget build(BuildContext context) {
    final loading = Provider.of<userProvider>(context);
    final screensize = MediaQuery.of(context).size;
    final user = Provider.of<userProvider>(context).getUser;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ClipOval(
                    child: CachedNetworkImage(
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                      imageUrl: widget.userProfile.toString(),
                      placeholder: (context, url) =>
                          new CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          new Icon(Icons.error),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.userName.toString(),
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                ],
              ),
              InkWell(
                  onTap: () {
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                              border: Border.all(),
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: Center(
                                            child: IconButton(
                                                onPressed: () {},
                                                icon: const Icon(
                                                  Icons.share,
                                                  size: 35,
                                                )),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const Text("Share")
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                              border: Border.all(),
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: Center(
                                            child: IconButton(
                                                onPressed: () {},
                                                icon: const Icon(
                                                  Icons.link,
                                                  size: 35,
                                                )),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const Text("Link")
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                              border: Border.all(),
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: Center(
                                            child: IconButton(
                                                onPressed: () {},
                                                icon: const Icon(
                                                  Icons
                                                      .bookmark_outline_outlined,
                                                  size: 35,
                                                )),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const Text("Save")
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                              border: Border.all(),
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: Center(
                                            child: IconButton(
                                                onPressed: () {},
                                                icon: const Icon(
                                                  Icons.qr_code,
                                                  size: 35,
                                                )),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const Text("Qr code")
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const Divider(
                                height: 10,
                              ),
                              ListView(
                                keyboardDismissBehavior:
                                    ScrollViewKeyboardDismissBehavior.onDrag,
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  ListTile(
                                    leading: Icon(Ionicons.archive_outline),
                                    title: Text("Archive"),
                                  ),
                                  ListTile(
                                    leading:
                                        Icon(Ionicons.heart_dislike_outline),
                                    title: Text("Hide like count"),
                                  ),
                                  ListTile(
                                    leading:
                                        Icon(Icons.comments_disabled_outlined),
                                    title: Text("Turn off commenting"),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (builder) => EditPost(
                                                    postUrl:
                                                        widget.postimageUrl,
                                                    postId: widget.postId,
                                                    description:
                                                        widget.description,
                                                    postingTime:
                                                        widget.dateTime,
                                                  )));
                                    },
                                    leading: Icon(Icons.edit_outlined),
                                    title: Text("Edit"),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.pin_end),
                                    title: Text("Unpin from profile"),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.share),
                                    title: Text("Post to other apps..."),
                                  ),
                                  ListTile(
                                    onTap: () async {
                                      await deletePost
                                          .deletePost(widget.postId!)
                                          .then((value) {
                                        Navigator.pop(context);
                                        Fluttertoast.showToast(
                                            msg: "post deleted");
                                      });
                                    },
                                    leading: Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                                    title: Text("Delete"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: const Icon(Icons.more_vert))
            ],
          ),
        ),
        InstaLikeButton(
          image: NetworkImage(widget.postimageUrl.toString()),
          onChanged: () {
            likes.likePost(widget.postId!, user.id!, widget.likes!);
          },
          icon: Icons.favorite,
          iconSize: 80,
          iconColor: Colors.red,
          height: screensize.height / 2.2,
          duration: const Duration(seconds: 1),
          onImageError: (e, _) {
            print(e);
          },
          imageBoxfit: BoxFit.cover,
        ),
        const SizedBox(
          height: 1,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      likes.likePost(widget.postId!, user.id!, widget.likes!);
                    },
                    child: Icon(
                      widget.likes!.contains(user.id)
                          ? Icons.favorite
                          : Icons.favorite_border_outlined,
                      color: widget.likes!.contains(user.id)
                          ? Colors.red
                          : Colors.black,
                      size: 27,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => CommentScreen(
                                    postId: widget.postId,
                                    description: widget.description,
                                    userProfile: widget.userProfile,
                                  )));
                    },
                    child: const Icon(
                      Icons.comment_outlined,
                      size: 27,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(
                    Icons.send,
                    size: 27,
                  )
                ],
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isbookmarked ? isbookmarked = false : isbookmarked = true;
                  });
                },
                child: Icon(
                  !isbookmarked ? Icons.bookmark_outline : Icons.bookmark,
                  color: Colors.black,
                  size: 30,
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            widget.likes!.isEmpty ? "" : "${widget.likes!.length} likes",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(left: 10, top: 2),
            child: RichText(
              text: TextSpan(
                text: widget.userName,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: ' ${widget.description.toString()}',
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            )),
        Padding(
            padding: EdgeInsets.only(left: 10, top: 5),
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => CommentScreen(
                                postId: widget.postId,
                                description: widget.description,
                                userProfile: widget.userProfile,
                              )));
                },
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("posts")
                        .doc(widget.postId)
                        .collection("comments")
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('');
                      } else {
                        return snapshot.data!.docs.isEmpty
                            ? Text("")
                            : Text(
                                "view all ${snapshot.data!.docs.length} comments");
                      }
                    }))),
        Padding(
          padding: const EdgeInsets.only(
            left: 10,
          ),
          child: Row(
            children: [
              Text(
                time().toString(),
                style: const TextStyle(fontSize: 10),
              ),
            ],
          ),
        )
      ]),
    );
  }

  time() {
    var NowDateTime = DateTime.now();
    var postingTime = widget.dateTime;
    final Duration duration =
        NowDateTime.difference(DateTime.parse(postingTime!));
    if (duration.inMinutes == 0 && duration.inHours == 0) {
      return "now";
    } else if (duration.inHours == 0 && duration.inMinutes <= 59) {
      return "${duration.inMinutes}m ago";
    } else if (duration.inMinutes > 59 && duration.inHours <= 24) {
      return "${duration.inHours}h ago";
    } else if (duration.inHours > 24 && duration.inDays <= 30) {
      return "${duration.inDays}d ago";
    } else if (duration.inDays > 30) {
      return DateFormat.yMMMMd().format(DateTime.parse(widget.dateTime!));
    } else {
      return widget.dateTime;
    }
  }

  bool islike = false;
  bool isbookmarked = false;
}
