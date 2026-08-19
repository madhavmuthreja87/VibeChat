import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vibechat/api/apis.dart';
import 'package:vibechat/helper/dialog.dart';

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

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Future<UserCredential?> signInWithGoogle() async {
    // Navigator.pop(context);
    try {
      await _googleSignIn.initialize();

      await InternetAddress.lookup("google.com");
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      Dialogs.showSnackBar(context, "Something went wrong(Check Internet)");
      print("Google Sign-in Error: $e");
      return null;
    }
  }

  _handleGoogleButtonClick() async {
    Dialogs.showProgressBar(context);
    await signInWithGoogle();
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      print(
        '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!              User Details:            !!!!!!!!!!!!!!!!!!111',
      );

      print(user);
      print(user?.displayName);
      print(user?.email);

      if (await Apis.userExists()) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        await Apis.createUser().then(
          (value) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          ),
        );
      }
    }
  }

  _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn.instance.signOut();
    } catch (e) {
      print("Sign out error: $e");
    }
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
              onPressed: () async {
                print(
                  "!!!!!!!!!!!!!!!!!              Google SignIn button Tapped              !!!!!!!!!!!!!!!",
                );
                await _handleGoogleButtonClick();
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
