import 'package:flutter/material.dart';
import 'package:instagram_clone/BackEnd/signIn.dart';
import 'package:instagram_clone/Utils/colors.dart';

class SignInUser extends StatefulWidget {
  const SignInUser({Key? key}) : super(key: key);

  @override
  State<SignInUser> createState() => _SignInUserState();
}

class _SignInUserState extends State<SignInUser> {
  final signInUser = SigningInUser();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailcontoller = TextEditingController();
  final passwordcontroller = TextEditingController();
  bool _ispasswordVisible = true;
  @override
  void initState() {
    super.initState();
    _ispasswordVisible = false;
  }

  bool loading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailcontoller.dispose();
    passwordcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.maybeOf(context)!.size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Container(
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
                        height: screenSize.height / 9,
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, left: 10),
                          child: Image.asset(
                            "images/logo.png",
                            color: primaryColor,
                            height: 80,
                            width: 180,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenSize.height / 14,
                      ),
                      Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 25, right: 25),
                            child: Column(
                              children: [
                                Email(),
                                const SizedBox(
                                  height: 10,
                                ),
                                Password(),
                                const SizedBox(
                                  height: 5,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                        onTap: () {},
                                        child: const Text(
                                          "Forgot your login details?",
                                          style: TextStyle(color: primaryColor),
                                        )),
                                    GestureDetector(
                                        onTap: () {},
                                        child: const Text(
                                          "Get help logging in",
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: primaryColor),
                                        ))
                                  ],
                                ),
                                const SizedBox(height: 30),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        shadowColor: Colors.grey,
                                        elevation: 3,
                                        minimumSize:
                                            const Size(double.infinity, 45)),
                                    onPressed: () async {
                                      FocusScope.of(context).unfocus();
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          loading = true;
                                        });
                                        await signInUser.userSigin(
                                            emailcontoller.text.trim(),
                                            passwordcontroller.text.trim(),
                                            context);

                                        setState(() {
                                          loading = false;
                                        });
                                      }
                                    },
                                    child: loading
                                        ? CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : const Text(
                                            "Log In",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          )),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextButton(
                                    onPressed: () {},
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      // ignore: prefer_const_literals_to_create_immutables
                                      children: [
                                        const Icon(
                                          Icons.facebook,
                                          color: primaryColor,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text(
                                          "Continue as AbdulSalam",
                                          style: const TextStyle(
                                              color: primaryColor),
                                        )
                                      ],
                                    )),
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
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "SignUp");
                    },
                    child: const Text(
                      "Don't have an account? Sign up",
                      style: TextStyle(color: primaryColor),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

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
              hintText: "Phone number,email,or username",
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
        obscureText: !_ispasswordVisible,
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
                  _ispasswordVisible = !_ispasswordVisible;
                });
              },
              icon: Icon(
                _ispasswordVisible ? Icons.visibility : Icons.visibility_off,
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
