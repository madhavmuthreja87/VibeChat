import 'dart:convert';

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vibechat/api/apis.dart';
import 'package:vibechat/helper/dialog.dart';

import 'package:vibechat/models/chat_user.dart';
import 'package:vibechat/screens/auth/login_screen.dart';
import 'package:vibechat/widgets/chat_user_card.dart';

import '../main.dart';

class ProfileScreen extends StatefulWidget {
  final Chat_User user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Profile Screen"),
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
        ),

        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: FloatingActionButton.extended(
            elevation: 10,
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(25),
            ),
            label: Text("Log out", style: TextStyle(color: Colors.white)),
            icon: Icon(Icons.logout_outlined, color: Colors.white),
            onPressed: () async {
              Dialogs.showProgressBar(context);
              await FirebaseAuth.instance.signOut();
              await GoogleSignIn.instance.signOut().then((value) {
                //to hiding progress dialog
                Navigator.pop(context);

                //for moving to home screen
                Navigator.pop(context);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              });
            },
          ),
        ),

        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * 0.05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(width: mq.width, height: mq.height * .03),
                  Stack(
                    children: [
                      _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadiusGeometry.circular(
                                mq.height * .4,
                              ),
                              child: CachedNetworkImage(
                                width: mq.height * .2,
                                height: mq.height * .2,
                                fit: BoxFit.fill,
                                imageUrl: widget.user.image!,
                                placeholder: (context, url) =>
                                    CircleAvatar(child: Icon(Icons.person)),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            )
                          : Icon(Icons.person),

                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          elevation: 13,
                          color: Colors.amber,
                          onPressed: () {
                            _showBottomSheet();
                          },
                          child: Icon(Icons.edit, color: Colors.white),
                          shape: CircleBorder(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: mq.height * .03),
                  Text(
                    widget.user.email!,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  SizedBox(height: mq.height * .03),
                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (val) => Apis.me.name = val ?? "",
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : "Required field",
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      prefixIcon: Icon(Icons.person, color: Colors.orange),
                      hintText: "e.g. Elon Musk",
                      label: Text("Name"),
                    ),
                  ),

                  SizedBox(height: mq.height * .02),

                  TextFormField(
                    initialValue: widget.user.about!,
                    onSaved: (val) => Apis.me.about = val ?? "",
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : "Required field",
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      prefixIcon: Icon(
                        Icons.info_outline,
                        color: Colors.orange,
                      ),
                      hintText: "e.g. Hey I am using Vibe Chat",
                      label: Text("About"),
                    ),
                  ),
                  SizedBox(height: mq.height * .05),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      minimumSize: Size(mq.width * .055, mq.height * .055),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        log("Inside Validator");
                        await Apis.UpdateUserInfo().then((value) {
                          Dialogs.showSnackBar(
                            context,
                            "Profile Updated Successfully",
                          );
                        });
                      }
                    },
                    label: const Text("UPDATE"),
                    icon: Icon(Icons.edit),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(
            top: mq.height * 0.03,
            bottom: mq.height * 0.07,
          ),
          children: [
            const Text(
              "Pick Profile Picture",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: mq.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    fixedSize: Size(mq.width * 0.3, mq.height * 0.15),
                  ),
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.gallery,
                    );

                    if (image != null) {
                      log(
                        "Image Path: ${image.path}  --  MimeType: ${image.mimeType}",
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Image.asset("images/icons8-gallery-64.png"),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    fixedSize: Size(mq.width * 0.3, mq.height * 0.15),
                  ),
                  onPressed: () {},
                  child: Image.asset("images/icons8-camera-100.png"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
