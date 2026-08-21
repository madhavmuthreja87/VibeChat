import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:vibechat/main.dart';
import 'package:vibechat/models/chat_user.dart';

class ChatUserCard extends StatefulWidget {
  final Chat_User user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(15),
      ),
      child: InkWell(
        onTap: () {},
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(mq.height * .03),
            child: CachedNetworkImage(
              width: mq.height * .055,
              height: mq.height * .055,
              imageUrl: widget.user.image!,

              placeholder: (context, url) => CircleAvatar(
                child: Icon(Icons.person),
              ), //CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          title: Text(widget.user.name!),
          subtitle: Text(widget.user.about!, maxLines: 1),
          // trailing: Text(
          //   widget.user.lastActive!,
          //   style: TextStyle(color: Colors.black54),
          // ),
          trailing: Container(
            height: 15,
            width: 15,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
