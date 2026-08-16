import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibechat/firebase_options.dart';

import 'package:vibechat/screens/splash_screen.dart';

//global object for accessing device screen size
late Size mq;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //to get full screen while opening splash screen,means buttons should not visible
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  ); //Exits full Screen

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) {
    _initializeFirebase();
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Vibe Chat",
      theme: ThemeData(
        primaryColor: Colors.orange,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: const Color.fromARGB(255, 248, 204, 147),
        ),
        appBarTheme: AppBarTheme(
          //Ek baar app bar ka theme decide krna padega bass
          elevation: 1,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.white,
            fontSize: 19,
          ),
          iconTheme: IconThemeData(color: Colors.black),

          backgroundColor: Colors.transparent,
        ),
      ),

      home: const SplashScreen(),
    );
  }
}

_initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
