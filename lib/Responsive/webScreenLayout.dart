import 'package:flutter/material.dart';
import 'package:instagram_clone/BackEnd/AuthState.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AuthServices().handleState(),
      ),
    );
  }
}
