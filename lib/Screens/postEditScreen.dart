import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instagram_clone/Utils/colors.dart';
import 'package:instagram_clone/providers/userProvider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditPost extends StatefulWidget {
  String? postUrl;
  String? description;
  String? postId;
  String? postingTime;
  EditPost({this.postId, this.description, this.postUrl, this.postingTime});

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  var updateDescriptionController = TextEditingController();
  @override
  void initState() {
    super.initState();
    updateDescriptionController.text = widget.description!;
  }

  bool isupdatign = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<userProvider>(context).getUser;
    final screensize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.cancel,
              color: Colors.black,
            )),
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Text(
          "Edit Info",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                setState(() {
                  isupdatign = true;
                });
                await FirebaseFirestore.instance
                    .collection("posts")
                    .doc(widget.postId)
                    .update({
                  "postDescription": updateDescriptionController.text
                }).then((value) {
                  Navigator.pushReplacementNamed(context, "HomeScreen");
                  Fluttertoast.showToast(msg: "Post updated");
                  isupdatign = false;
                });
              },
              icon: const Icon(
                Icons.done,
                color: Colors.black,
              ))
        ],
      ),
      body: isupdatign
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
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
                                imageUrl: user.profilePic.toString(),
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
                              user.userName.toString(),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                        Text(DateFormat.yMMMd()
                            .format(DateTime.parse(widget.postingTime!)))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      maxLines: 3,
                      decoration: InputDecoration(),
                      controller: updateDescriptionController,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: screensize.height / 2.2,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: widget.postUrl!,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
