import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/BackEnd/EditProfile.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Utils/colors.dart';
import 'package:instagram_clone/providers/userProvider.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  void initState() {
    super.initState();
    final userprovider =
        Provider.of<userProvider>(context, listen: false).getUser;
    userNameController.text = userprovider.userName!;
    fullNameController.text = userprovider.fullName!;
    biocontroller.text = userprovider.bio!;
  }

  bool changeImage = false;

  final userNameController = TextEditingController();
  final fullNameController = TextEditingController();
  final biocontroller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final screensize = MediaQuery.of(context).size;
    final user = Provider.of<userProvider>(context).getUser;
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.cancel,
              color: Colors.black,
            )),
        actions: [
          IconButton(
              onPressed: () async {
                await EditProfileBackend().editMyProfile(
                    filePath,
                    image,
                    biocontroller.text.trim(),
                    userNameController.text.trim(),
                    fullNameController.text.trim(),
                    context);
              },
              icon: const Icon(
                Icons.done,
                color: Colors.blue,
              ))
        ],
      ),
      body: Column(
        children: [
          Stack(
            children: [
              user.profilePic == null
                  ? CircleAvatar(
                      onBackgroundImageError: ((exception, stackTrace) {}),
                      radius: screensize.width / 5,
                      backgroundImage: const AssetImage("images/default.jpg"),
                    )
                  : image == null
                      ? CircleAvatar(
                          radius: screensize.width / 5,
                          backgroundImage: NetworkImage(user.profilePic!),
                        )
                      : CircleAvatar(
                          radius: screensize.width / 5,
                          backgroundImage: FileImage(image!),
                        ),
              Positioned(
                bottom: 1,
                right: -1,
                child: IconButton(
                    onPressed: () {
                      PickImage();
                    },
                    icon: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    )),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Text("Change profile photo"),
          const SizedBox(
            height: 20,
          ),
          Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Column(
                  children: [
                    name(),
                    const SizedBox(
                      height: 5,
                    ),
                    userName(),
                    const SizedBox(
                      height: 5,
                    ),
                    bio(),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  bool loading = false;
  String? filePath;
  FirebaseStorage _storage = FirebaseStorage.instance;
  File? image;
  final ImagePicker _picker = ImagePicker();
  void PickImage() async {
    final PickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = File(PickedFile!.path);
      print(image);
    });
    filePath = path.basename(image!.path);
  }

  Widget name() {
    return SizedBox(
      height: 50,
      child: TextFormField(
          validator: (name) {
            if (name!.isEmpty) {
              return "name can't be empty.";
            }
          },
          controller: fullNameController,
          decoration: const InputDecoration(
            hintText: "Name",
          )),
    );
  }

  Widget userName() {
    return SizedBox(
      height: 50,
      child: TextFormField(
          validator: (name) {
            if (name!.isEmpty) {
              return "username can't be empty.";
            }
          },
          controller: userNameController,
          decoration: const InputDecoration(
            hintText: "Username",
          )),
    );
  }

  Widget bio() {
    return SizedBox(
      height: 50,
      child: TextFormField(
          controller: biocontroller,
          decoration: const InputDecoration(
            hintText: "bio",
          )),
    );
  }
}
