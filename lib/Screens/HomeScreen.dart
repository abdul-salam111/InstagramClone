import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Utils/globalVariables.dart';
import 'package:instagram_clone/providers/userProvider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  addData() async {
    userProvider provider = Provider.of<userProvider>(context, listen: false);
    await provider.getUserDetail();
  }

  late PageController pageController;
  int page = 0;
  void navigationTapped(pageNo) {
    pageController.jumpToPage(pageNo);
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<userProvider>(context).getUser;
    return Scaffold(
      bottomNavigationBar: CupertinoTabBar(
        onTap: (value) {
          navigationTapped(value);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              page == 0 ? Icons.home : Icons.home_outlined,
              color: Colors.black,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: Colors.black,
              size: page == 1 ? 35 : 30,
            ),
            label: "",
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle_outline,
              color: Colors.black,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              page == 3
                  ? Icons.favorite_rounded
                  : Icons.favorite_outline_outlined,
              color: Colors.black,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: ClipOval(
              child: CachedNetworkImage(
                height: 35,
                width: 35,
                fit: BoxFit.cover,
                imageUrl: user.profilePic.toString(),
                placeholder: (context, url) => new CircularProgressIndicator(),
                errorWidget: (context, url, error) => new Icon(Icons.error),
              ),
            ),
            label: "",
          )
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: homeScreenItems,
        onPageChanged: (val) {
          setState(() {
            page = val;
          });
        },
      ),
    );
  }
}
