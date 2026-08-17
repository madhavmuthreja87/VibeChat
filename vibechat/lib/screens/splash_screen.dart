import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibechat/screens/auth/login_screen.dart';
import 'package:vibechat/screens/home_screen.dart';

import '../../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(const Duration(milliseconds: 1500), () {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge,
      ); //Back to screen with buttons

      if (FirebaseAuth.instance.currentUser == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } else {
        print(
          "!!!!!!!!!!!!!!!!!!!!!!!!!                             User details (Already Logged In): ${FirebaseAuth.instance.currentUser}                        !!!!!!!!!!!!!!!!!!!!!!",
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Vibe Chat"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFDC70C), Color(0xFFF4933D), Color(0xFFE93E3A)],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: mq.height * .15,
            left: mq.width * .25,
            width: mq.width * .5,
            height: mq.height * .3,

            child: Image.asset('images/icon.png'),
          ),
          Positioned(
            bottom: mq.height * .12,
            width: mq.width,
            height: mq.height * .06,

            child: const Text(
              "MADE IN INDIA WITH ❤️",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
                letterSpacing: .3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
