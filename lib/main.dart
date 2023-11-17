import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Responsive/mobileLayout.dart';
import 'package:instagram_clone/Responsive/responsiveLayout.dart';
import 'package:instagram_clone/Responsive/webScreenLayout.dart';
import 'package:instagram_clone/Screens/HomeScreen.dart';
import 'package:instagram_clone/Screens/SignUp.dart';
import 'package:instagram_clone/Screens/loginScreen.dart';

import 'package:instagram_clone/providers/userProvider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCjNncpXXykxN2-5y6AsfZ-kfdEf8iWdlU",
            appId: "1:163985833082:web:9972e3dfb3f951df804fc3",
            messagingSenderId: "163985833082",
            projectId: "instagram-6140d",
            storageBucket: "instagram-6140d.appspot.com"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<userProvider>(create: (_) => userProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
<<<<<<< HEAD
        title: 'Instagram This is second branch',
=======
        title: 'Instagram this is new branch',
>>>>>>> new-branch
        routes: {
          "HomeScreen": (context) => HomeScreen(),
          "SignIn": (context) => SignInUser(),
          "SignUp": (context) => SignUp(),
        },
        home: const ResponsiveLayout(
          webScreenLayout: WebScreenLayout(),
          mobileScreenLayout: MobileScreenLayout(),
        ),
      ),
    );
  }
}
