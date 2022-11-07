import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/BackEnd/uploadStories.dart';
import 'package:instagram_clone/Utils/colors.dart';
import 'package:instagram_clone/providers/userProvider.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

class CreateStories extends StatefulWidget {
  const CreateStories({Key? key}) : super(key: key);

  @override
  State<CreateStories> createState() => _CreateStoriesState();
}

class _CreateStoriesState extends State<CreateStories> {
  ImagePicker _picker = ImagePicker();
  String? filePath;
  File? image;

  void PickImage() async {
    final PickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (PickedFile != null) {
      setState(() {
        image = File(PickedFile.path);
        print(image);
      });
      filePath = path.basename(image!.path);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PickImage();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<userProvider>(context).getUser;
    return Scaffold(
        appBar: AppBar(
          title: Text("Add to story"),
          centerTitle: true,
          backgroundColor: primaryColor,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          actions: [
            TextButton(
                onPressed: () {
                  Stories().uploadStories(image, filePath,
                      FirebaseAuth.instance.currentUser!.uid, user.userName);
                },
                child: Text(
                  "Upload",
                  style: TextStyle(color: Colors.black),
                )),
          ],
        ),
        body: image != null
            ? Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image(
                      image: FileImage(image!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              )
            : Center());
  }
}
