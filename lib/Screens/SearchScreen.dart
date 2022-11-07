import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Screens/ProfileScreen.dart';

import 'package:instagram_clone/Utils/colors.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchController = TextEditingController();
  bool isSearch = false;
  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
    isSearch = false;
  }

  String searchuser = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: primaryColor,
          title: SizedBox(
            height: 30,
            child: TextField(
              controller: searchController,
              onSubmitted: (val) {
                setState(() {
                  isSearch = true;
                });
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  label: const Text("Search"),
                  fillColor: Colors.grey.withOpacity(0.5),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  filled: true),
            ),
          ),
        ),
        body: isSearch
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("Users")
                    .where(
                      "userName",
                      isLessThanOrEqualTo: searchController.text,
                    )
                    .orderBy("userName", descending: true)
                    .get(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: ((context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => MyAccount(
                                          uid: snapshot.data!.docs[index]["id"],
                                        )));
                          },
                          child: ListTile(
                            title: Text(snapshot.data!.docs[index]["userName"]),
                            leading: ClipOval(
                              child: CachedNetworkImage(
                                height: 45,
                                width: 45,
                                fit: BoxFit.cover,
                                imageUrl: snapshot
                                    .data!.docs[index]["profilePic"]
                                    .toString(),
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                        );
                      }));
                },
              )
            : StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection("posts").snapshots(),
                builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return StaggeredGridView.countBuilder(
                        itemCount: snapshot.data!.docs.length,
                        crossAxisCount: 3,
                        itemBuilder: (context, index) {
                          return CachedNetworkImage(
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                            imageUrl: snapshot.data!.docs[index]["postUrl"],
                            placeholder: (context, url) => Center(
                                child: const CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          );
                        },
                        staggeredTileBuilder: (index) {
                          return StaggeredTile.count((index % 7 == 0) ? 2 : 1,
                              (index % 7 == 0) ? 2 : 1);
                        });
                  }
                })));
  }
}
