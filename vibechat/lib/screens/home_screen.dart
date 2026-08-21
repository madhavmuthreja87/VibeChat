import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as CuppertinoIcons;
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
  //for storing all users
  List<Chat_User> _list = [];

  //for storing searched items
  final List<Chat_User> _searchList = [];

  //for storing  search status
  bool isSearching = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Apis.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: () {
          if (isSearching) {
            setState(() {
              isSearching = !isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value((true));
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: isSearching
                ? TextField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Name,email....",
                    ),
                    autofocus: true,
                    style: TextStyle(fontSize: 17, letterSpacing: 0.6),
                    onChanged: (value) {
                      _searchList.clear();
                      //search logic
                      if (value.isNotEmpty) {
                        for (var i in _list) {
                          if (!_searchList.contains(value) &&
                              (i.name!.toLowerCase().contains(
                                    value.toLowerCase(),
                                  ) ||
                                  i.email!.toLowerCase().contains(
                                    (value.toLowerCase()),
                                  ))) {
                            _searchList.add(i);
                          }
                          setState(() {
                            _searchList;
                          });
                        }
                      }
                    },
                  )
                : Text("Vibe Chat"),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFDC70C),
                    Color(0xFFF4933D),
                    Color(0xFFE93E3A),
                  ],
                ),
              ),
            ),
            leading: Icon(Icons.home),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    isSearching = !isSearching;
                  });
                },
                icon: Icon(
                  isSearching ? CuppertinoIcons.Icons.clear : Icons.search,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProfileScreen(user: Apis.me),
                    ),
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

                _list = data.map((e) => Chat_User.fromJson(e.data())).toList();
                if (_list.isNotEmpty) {
                  return ListView.builder(
                    itemCount: isSearching ? _searchList.length : _list.length,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(top: mq.height * 0.01),
                    itemBuilder: (context, index) {
                      final user = isSearching
                          ? _searchList[index]
                          : _list[index];

                      return ChatUserCard(user: user);
                    },
                  );
                } else {
                  return Center(
                    child: Text(
                      "No chat found!",
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                }
              } else {
                return Center(
                  child: Text("No chat found!", style: TextStyle(fontSize: 20)),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
