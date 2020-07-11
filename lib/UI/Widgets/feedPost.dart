import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:morsey_gaming_social_hub/Models/post.dart';
import 'package:morsey_gaming_social_hub/Models/user.dart';
import 'package:morsey_gaming_social_hub/UI/Widgets/UserProfilePic.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:assets_audio_player/assets_audio_player.dart';

class FeedPost extends StatefulWidget {
  final Post post;
  final User user;
  FeedPost(this.post,this.user);
  @override
  _FeedPostState createState() => _FeedPostState();
}

class _FeedPostState extends State<FeedPost> {
  @override
  final assetsAudioPlayer = AssetsAudioPlayer();
  bool gg =false;
  bool f=false;
  bool rip=false;
  Widget build(BuildContext context) {
    ggHandler() async{
      final x= await Firestore.instance.collection('games').document(widget.post.slug).get();
      List a= x.data['followers'];
      if(widget.post.gg.contains(widget.user.email)||gg==true)
        {
          setState(() {
            gg=false;
          });
          await Firestore.instance.collection('games').document(widget.post.slug).collection("posts").document(widget.post.postId).updateData({"gg":FieldValue.arrayRemove([widget.user.email])});
          a.forEach((element) {
            Firestore.instance.collection('users').document(element).collection("feed").document(widget.post.postId).updateData({"gg":FieldValue.arrayRemove([widget.user.email])});
          });
        }
      else{
        assetsAudioPlayer.open(
          Audio("assets/impress.mp3"),
          );
        await Firestore.instance.collection('games').document(widget.post.slug).collection("posts").document(widget.post.postId).updateData({"gg":FieldValue.arrayUnion([widget.user.email])});
          a.forEach((element) {
            Firestore.instance.collection('users').document(element).collection("feed").document(widget.post.postId).updateData({"gg":FieldValue.arrayUnion([widget.user.email])});
          });
          setState(() {
            gg=true;
          });
      }
    }
    fHandler() async{
      final x= await Firestore.instance.collection('games').document(widget.post.slug).get();
      List a= x.data['followers'];
      if(widget.post.f.contains(widget.user.email)||f==true)
        {
          setState(() {
            f=false;
          });
          await Firestore.instance.collection('games').document(widget.post.slug).collection("posts").document(widget.post.postId).updateData({"f":FieldValue.arrayRemove([widget.user.email])});
          a.forEach((element) {
            Firestore.instance.collection('users').document(element).collection("feed").document(widget.post.postId).updateData({"f":FieldValue.arrayRemove([widget.user.email])});
          });
        }
      else{
        assetsAudioPlayer.open(
          Audio("assets/humilation.mp3"));
        await Firestore.instance.collection('games').document(widget.post.slug).collection("posts").document(widget.post.postId).updateData({"f":FieldValue.arrayUnion([widget.user.email])});
          a.forEach((element) {
            Firestore.instance.collection('users').document(element).collection("feed").document(widget.post.postId).updateData({"f":FieldValue.arrayUnion([widget.user.email])});
          });
          setState(() {
            f=true;
          });
      }
    }
    ripHandler() async{
      final x= await Firestore.instance.collection('games').document(widget.post.slug).get();
      List a= x.data['followers'];
      if(widget.post.rip.contains(widget.user.email)||rip==true)
        {
          setState(() {
            rip=false;
          });
          await Firestore.instance.collection('games').document(widget.post.slug).collection("posts").document(widget.post.postId).updateData({"rip":FieldValue.arrayRemove([widget.user.email])});
          a.forEach((element) {
            Firestore.instance.collection('users').document(element).collection("feed").document(widget.post.postId).updateData({"rip":FieldValue.arrayRemove([widget.user.email])});
          });
        }
      else{
        assetsAudioPlayer.open(
          Audio("assets/multikill.mp3"),
        );
        await Firestore.instance.collection('games').document(widget.post.slug).collection("posts").document(widget.post.postId).updateData({"gg":FieldValue.arrayUnion([widget.user.email])});
          a.forEach((element) {
            Firestore.instance.collection('users').document(element).collection("feed").document(widget.post.postId).updateData({"rip":FieldValue.arrayUnion([widget.user.email])});
          });
          setState(() {
            rip=true;
          });
      }
    }
    return GestureDetector(
      onTap: () {
      },
      child: Container(
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
            SizedBox(height: 15),
            Row(
              children: <Widget>[
                FlatButton(
                  onPressed: () {ggHandler();},
                  child: Row(
                    children: [
                      Image.asset("assets/gg.png",width: 30,height: 30,),
                      SizedBox(width:5),
                      Text(
                      "${widget.post.getGGCount(widget.post.gg)}",
                      style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(
                            color: Color(0xff67FD9A),
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ],
                  ),
                ),
                FlatButton(
                  onPressed: () {fHandler();},
                  child: Row(
                    children: [
                      Image.asset("assets/f.png",width: 40,height: 30,),
                      SizedBox(width:5),
                      Text(
                      "${widget.post.getFCount(widget.post.f)}",
                      style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(
                            color: Color(0xff67FD9A),
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ],
                  ),
                ),
                FlatButton(
                  onPressed: () {ripHandler();},
                  child: Row(
                    children: [
                      Image.asset("assets/rip.png",width: 30,height: 30,),
                      SizedBox(width:5),
                      Text(
                      "${widget.post.geripCount(widget.post.rip)}",
                      style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(
                            color: Color(0xff67FD9A),
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ],
                  ),
                ),
                FlatButton(
                  onPressed: () {},
                  child:Icon(Icons.comment,size: 30,color: Colors.white,),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}