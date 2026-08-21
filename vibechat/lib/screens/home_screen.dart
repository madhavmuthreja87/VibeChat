import 'dart:convert';
import 'dart:math' hide log;
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vibechat/api/apis.dart';
import 'package:vibechat/main.dart';
import 'package:vibechat/models/chat_user.dart';
import 'package:vibechat/screens/profile_screen.dart';
import 'package:vibechat/widgets/chat_user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Chat_User> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Apis.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vibe Chat"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFDC70C), Color(0xFFF4933D), Color(0xFFE93E3A)],
            ),
          ),
        ),
        leading: Icon(Icons.home),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfileScreen(user: Apis.me)),
              );
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: FloatingActionButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            await GoogleSignIn.instance.signOut();
          },
          child: Icon(Icons.add_comment, color: Colors.deepOrange),
        ),
      ),

      body: StreamBuilder(
        stream: Apis.getAllUsers(),
        builder: (context, snapshot) {
          // if (snapshot.hasError) {
          //   log("Firestore Error: ${snapshot.error}");
          //   return Center(child: Text("Error: ${snapshot.error}"));
          // }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final data = snapshot.data!.docs;

            for (var d in data) {
              log("data: ${jsonEncode(d.data())}");
            }

            list = data.map((e) => Chat_User.fromJson(e.data())).toList();
            if (list.isNotEmpty) {
              return ListView.builder(
                itemCount: list.length,
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.only(top: mq.height * 0.01),
                itemBuilder: (context, index) {
                  final user = list[index];

                  return ChatUserCard(user: user);
                },
              );
            } else {
              return Center(
                child: Text("No chat found!", style: TextStyle(fontSize: 20)),
              );
            }
          } else {
            return Center(
              child: Text("No chat found!", style: TextStyle(fontSize: 20)),
            );
          }
        },
      ),
    );
  }
}
