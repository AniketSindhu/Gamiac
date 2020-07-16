import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:morsey_gaming_social_hub/Models/post.dart';
import 'package:morsey_gaming_social_hub/Models/user.dart';
import 'package:morsey_gaming_social_hub/UI/Widgets/UserProfilePic.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:assets_audio_player/assets_audio_player.dart';

class SinglePost extends StatefulWidget {
  final Post post;
  SinglePost(this.post);
  @override
  _SinglePostState createState() => _SinglePostState();
}

class _SinglePostState extends State<SinglePost> {
  @override
  final assetsAudioPlayer = AssetsAudioPlayer();
  bool gg =false;
  bool f=false;
  bool rip=false;
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff21252A),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
          },
          child: Container(
            margin: EdgeInsets.only(top:100),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                ),
              ),
            ),
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[ 
                    UserProfilePicture(
                      userId: widget.post.ownerEmail,
                      profilePicture: widget.post.profilePic
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                                "${widget.post.gamer_tag}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(
                                        color: Colors.white,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                ),
                          Text(
                                "${widget.post.ownerEmail}",
                                  style:TextStyle(color:Colors.grey,fontSize:13)
                                ), 
                        ],
                      ),
                    ),
                    Expanded(
                      child: Text(
                        timeago.format(
                            DateTime.parse(
                                "${widget.post.timestamp}"),
                            locale: "en"),
                        textAlign: TextAlign.end,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .copyWith(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 15.0),
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Image.network(
                      "${widget.post.mediaUrl}",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text(
                  "${widget.post.description}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 30,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}