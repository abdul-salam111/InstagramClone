import 'package:flutter/material.dart';
import 'package:instagram_clone/Utils/dimensions.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget? webScreenLayout;
  final Widget? mobileScreenLayout;
  const ResponsiveLayout(
      {Key? key, this.webScreenLayout, this.mobileScreenLayout})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: ((context, constraints) {
      if (constraints.maxWidth > webScreenSize) {
        return webScreenLayout!;
      } else {
        return mobileScreenLayout!;
      }
    }));
  }
}
