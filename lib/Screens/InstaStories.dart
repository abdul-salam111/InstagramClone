import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InstaStories extends StatefulWidget {
  const InstaStories({Key? key}) : super(key: key);

  @override
  State<InstaStories> createState() => _InstaStoriesState();
}

class _InstaStoriesState extends State<InstaStories> {
  static String collectionDbName = 'instagram_stories_db';
  CollectionReference dbInstance =
      FirebaseFirestore.instance.collection(collectionDbName);
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
