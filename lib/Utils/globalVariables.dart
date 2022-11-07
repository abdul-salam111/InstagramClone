import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Screens/ProfileScreen.dart';
import 'package:instagram_clone/Screens/SearchScreen.dart';
import 'package:instagram_clone/Screens/add_Post_Screen.dart';

import '../Screens/feedScreen.dart';

final homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Center(child: Text("favorite")),
  MyAccount(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
