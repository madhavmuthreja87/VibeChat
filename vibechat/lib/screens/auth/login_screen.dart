import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vibechat/screens/home_screen.dart';

import '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //   mq = MediaQuery.of(context).size;

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
          AnimatedPositioned(
            top: mq.height * .15,
            left: _isAnimate ? mq.width * .31 : mq.width * .5,

            width: mq.width * .4,
            height: mq.height * .3,
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: 800),
            child: Image.asset('images/icon.png'),
          ),
          Positioned(
            top: mq.height * .65,
            left: mq.width * .05,

            width: mq.width * .9,
            height: mq.height * .07,

            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shadowColor: Colors.blueGrey,
                backgroundColor: const Color.fromARGB(255, 248, 215, 171),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => HomeScreen()),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                    width: 30,
                    child: Image.asset("images/google.png"),
                  ),
                  RichText(
                    text: TextSpan(
                      text: "   Sign in with ",
                      style: TextStyle(color: Colors.black, fontSize: 17),
                      children: [
                        TextSpan(
                          text: "Google",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 19,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
