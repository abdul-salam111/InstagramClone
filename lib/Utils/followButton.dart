import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  String? buttonName;
  Color? btncolor;
  final VoidCallback? ontap;

  FollowButton({Key? key, this.buttonName, this.ontap, this.btncolor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ontap,
      child: Text(buttonName!),
      style: ElevatedButton.styleFrom(
          primary: btncolor, minimumSize: const Size(double.infinity, 30)),
    );
  }
}
