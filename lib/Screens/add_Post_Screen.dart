import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:instagram_clone/BackEnd/uploadPost.dart';
import 'package:instagram_clone/providers/userProvider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/Utils/colors.dart';
import 'package:instagram_clone/Utils/styles.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  late UploadPosts uploadPosts;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PickImage();
    uploadPosts = UploadPosts();
  }

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
      setState(() {
        cropped = false;
      });
    }
  }

  bool isUploading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    picDecriptionController.dispose();
  }

  final picDecriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.maybeOf(context)!.size;
    var user = Provider.of<userProvider>(context).getUser;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, "HomeScreen");
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: primaryColor,
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, "HomeScreen");
              },
              icon: const Icon(
                Icons.cancel,
                color: Colors.black,
                size: 30,
              )),
          title: const Text(
            "New Post",
            style: newpostStyle,
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  setState(() {
                    isUploading = true;
                  });
                  FocusScope.of(context).unfocus();
                  await uploadPosts.uploadPost(
                      user.userName!,
                      picDecriptionController.text.trim(),
                      user.id!,
                      user.profilePic!,
                      cropped ? File(croppedFile!.path) : image,
                      filePath,
                      context);
                  Navigator.pushReplacementNamed(context, "HomeScreen");
                },
                icon: const Icon(Icons.arrow_forward,
                    color: Colors.blue, size: 30))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                isUploading ? const LinearProgressIndicator() : Container(),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.profilePic.toString()),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: TextField(
                          controller: picDecriptionController,
                          decoration: const InputDecoration(
                              hintText: "Write a caption",
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                    image != null
                        ? Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: FileImage(image!),
                                    fit: BoxFit.fill)),
                          )
                        : const Center()
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                image != null
                    ? Stack(
                        children: [
                          Image(
                            image: cropped
                                ? FileImage(croppedFile != null
                                    ? File(croppedFile!.path)
                                    : image!)
                                : FileImage(image!),
                            height: screenSize.height / 2.5,
                            width: screenSize.width / 1,
                            fit: BoxFit.fill,
                          ),
                          Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                  onPressed: () {
                                    PickImage();
                                  },
                                  icon: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        border: Border.all(),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: const Center(
                                      child: Icon(
                                        Icons.edit,
                                        size: 25,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ))),
                          const SizedBox(
                            height: 10,
                          ),
                          Positioned(
                            top: 40,
                            right: 1,
                            child: IconButton(
                                onPressed: () async {
                                  croppedFile = await ImageCropper().cropImage(
                                    sourcePath: image!.path,
                                    aspectRatioPresets: [
                                      CropAspectRatioPreset.square,
                                      CropAspectRatioPreset.ratio3x2,
                                      CropAspectRatioPreset.original,
                                      CropAspectRatioPreset.ratio4x3,
                                      CropAspectRatioPreset.ratio16x9
                                    ],
                                    uiSettings: [
                                      AndroidUiSettings(
                                          toolbarTitle: 'Cropper',
                                          toolbarColor: Colors.deepOrange,
                                          toolbarWidgetColor: Colors.white,
                                          initAspectRatio:
                                              CropAspectRatioPreset.original,
                                          lockAspectRatio: false),
                                    ],
                                  );
                                  setState(() {
                                    cropped = true;
                                  });
                                },
                                icon: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: const Icon(
                                      Icons.crop,
                                      color: Colors.white,
                                      size: 30,
                                    ))),
                          )
                        ],
                      )
                    : const Center()
              ],
            ),
          ),
        ),
      ),
    );
  }

  CroppedFile? croppedFile;
  bool cropped = false;
}
