import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/BackEnd/SignUp.dart';
import 'package:instagram_clone/Utils/colors.dart';

import 'package:path/path.dart' as path;

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  RegisterUser registerUser = RegisterUser();
  bool ispasswordVisible = true;
  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ispasswordVisible = false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailcontoller.dispose();
    passwordcontroller.dispose();
    fullNameController.dispose();
    userNameController.dispose();
  }

  bool loading = false;
  String? filePath;
  FirebaseStorage _storage = FirebaseStorage.instance;
  File? image;
  void PickImage() async {
    final PickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = File(PickedFile!.path);
      print(image);
    });
    filePath = path.basename(image!.path);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.maybeOf(context)!.size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.1, 0.5, 1],
          colors: [Colors.purple, Colors.pink, Colors.orange],
        )),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: screenSize.height / 12,
              ),
              Container(
                  child: Image.asset(
                "images/logo.png",
                color: primaryColor,
                height: 80,
                width: 180,
                fit: BoxFit.cover,
              )),
              SizedBox(height: screenSize.height / 40),
              Stack(
                children: [
                  image == null
                      ? CircleAvatar(
                          onBackgroundImageError: ((exception, stackTrace) {}),
                          radius: screenSize.width / 5,
                          backgroundImage:
                              const AssetImage("images/default.jpg"),
                        )
                      : CircleAvatar(
                          radius: screenSize.width / 5,
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
              SizedBox(
                height: screenSize.height / 22,
              ),
              Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Column(
                      children: [
                        Email(),
                        const SizedBox(
                          height: 5,
                        ),
                        fullName(),
                        const SizedBox(
                          height: 5,
                        ),
                        userName(),
                        const SizedBox(
                          height: 5,
                        ),
                        Password(),
                        const SizedBox(
                          height: 5,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                shadowColor: Colors.grey,
                                elevation: 3,
                                minimumSize: const Size(double.infinity, 45)),
                            onPressed: () async {
                              FocusScope.of(context).unfocus();

                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                await registerUser.SignUpUser(
                                    emailcontoller.text.trim(),
                                    passwordcontroller.text.trim(),
                                    fullNameController.text.trim(),
                                    userNameController.text.trim(),
                                    context,
                                    image,
                                    filePath);
                              }
                            },
                            child: loading
                                ? CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "Sign Up",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  )),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "By signing up, you are agree to our\nTerms, Data Policy, and Cookies Policy.",
                          style: TextStyle(
                              fontSize: 14,
                              color: primaryColor,
                              fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // ignore: prefer_const_literals_to_create_immutables
                        Row(children: <Widget>[
                          const Expanded(
                              child: Divider(
                            color: primaryColor,
                          )),
                          const Text(
                            " OR ",
                            style: const TextStyle(color: primaryColor),
                          ),
                          const Expanded(
                              child: Divider(
                            color: primaryColor,
                          )),
                        ]),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, "SignIn");
                              },
                              child: const Text(
                                "Already have an account? Sign in",
                                style: const TextStyle(color: primaryColor),
                              )),
                        )
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final emailcontoller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final userNameController = TextEditingController();
  final fullNameController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Widget Email() {
    return SizedBox(
      height: 50,
      child: TextFormField(
          style: const TextStyle(color: Colors.white),
          validator: (email) {
            if (email!.isEmpty) {
              return "Email can't be empty.";
            } else if (!RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(email)) {
              return "Email should be correct.";
            }
          },
          controller: emailcontoller,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              errorStyle: const TextStyle(
                  color: primaryColor, decorationColor: Colors.white),
              fillColor: Colors.white.withAlpha(100),
              filled: true,
              hintText: "Email",
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)))),
    );
  }

  Widget fullName() {
    return SizedBox(
      height: 50,
      child: TextFormField(
          style: const TextStyle(color: Colors.white),
          validator: (name) {
            if (name!.isEmpty) {
              return "Name can't be empty.";
            }
          },
          controller: fullNameController,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              errorStyle: const TextStyle(
                  color: primaryColor, decorationColor: Colors.white),
              fillColor: Colors.white.withAlpha(100),
              filled: true,
              hintText: "Fullname",
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)))),
    );
  }

  Widget userName() {
    return SizedBox(
      height: 50,
      child: TextFormField(
          style: const TextStyle(color: Colors.white),
          validator: (name) {
            if (name!.isEmpty) {
              return "Username can't be empty.";
            }
          },
          controller: userNameController,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              errorStyle: const TextStyle(
                  color: primaryColor, decorationColor: Colors.white),
              fillColor: Colors.white.withAlpha(100),
              filled: true,
              hintText: "Username",
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)))),
    );
  }

  Widget Password() {
    return SizedBox(
      height: 50,
      child: TextFormField(
        validator: (password) {
          if (password!.isEmpty) {
            return "Password can't be empty.";
          } else if (password.length < 8) {
            return "Password should be of 8 characters.";
          }
        },
        style: const TextStyle(color: Colors.white),
        obscureText: !ispasswordVisible,
        controller: passwordcontroller,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.white.withAlpha(100),
            filled: true,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  ispasswordVisible = !ispasswordVisible;
                });
              },
              icon: Icon(
                ispasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.white,
              ),
            ),
            errorStyle: const TextStyle(
                color: primaryColor, decorationColor: Colors.white),
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            hintText: "Password"),
      ),
    );
  }
}
