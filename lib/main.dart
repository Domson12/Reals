import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reals/responsive/mobile_screen_layout.dart';
import 'package:reals/responsive/responisve_layout_screen.dart';
import 'package:reals/responsive/web_screen_layout.dart';
import 'package:reals/screens/signup_screen.dart';
import 'package:reals/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCYW233rSDx9zfsvwWMxZsBiNfxpk0Bhg4",
        appId: "1:437746491977:web:2f3039ac724c959a0a5598",
        messagingSenderId: "437746491977",
        projectId: "reals-76474",
        storageBucket: "reals-76474.appspot.com",
        measurementId: "437746491977",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Reals",
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: const SigninScreen()
        // const ResponsiveLayout(
        //   mobileScreenLayout: MobileScreenLayout(),
        //   webScreenLayout: WebScreenLayout(),
        );
  }
}
