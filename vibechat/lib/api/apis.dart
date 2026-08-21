import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vibechat/models/chat_user.dart';

class Apis {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static User get user => auth.currentUser!;

  static late Chat_User me;

  static Future<bool> userExists() async {
    return (await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }

  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(auth.currentUser!.uid).get().then((
      user,
    ) async {
      if (user.exists) {
        me = Chat_User.fromJson(user.data()!);
        log("MY DATA : ${user.data()}");
      } else {
        await createUser();
        await getSelfInfo();
      }
    });
  }

  static Future<void> createUser() async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();

    final chat_User = Chat_User(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      about: "Hey! I sam using vibe chat",
      image: user.photoURL.toString(),
      createdAt: time,
      isOnline: false,
      lastActive: time,
      pushToken: '',
    );
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chat_User.toJson());
  }

  // for getting all users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where("id", isNotEqualTo: user.uid)
        .snapshots();
  }

  static Future<void> UpdateUserInfo() async {
    try {
      await firestore.collection('users').doc(user.uid).update({
        'name': me.name,
        'about': me.about,
      });
      log("User info updated successfully");
    } catch (e) {
      log("Update eroor: $e");
    }
  }
}
