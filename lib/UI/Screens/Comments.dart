import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:morsey_gaming_social_hub/Methods/GoogleSignIn.dart';
import 'package:morsey_gaming_social_hub/Models/post.dart';
import 'package:morsey_gaming_social_hub/Models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Login.dart';

class Comments extends StatefulWidget {
  final Post post;
  final User user;
  Comments(this.user,this.post,);
  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final Firestore _firestore = Firestore.instance;
  bool english=false;
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  Future<void> callback() async {
    if (messageController.text.length > 0) {
      await _firestore.collection('games').document(widget.post.slug).collection('posts').document(widget.post.postId).collection("comments").add({
        'text': messageController.text,
        'from': widget.user.gamer_tag,
        'date': DateTime.now().toIso8601String().toString(),
      });
      messageController.clear();
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }
  void initState(){
    super.initState();
  }
    void dispose() {
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff21252A),
      appBar: AppBar(
          title:Text("Comments",style:GoogleFonts.bangers(textStyle:TextStyle(color:Color(0xff67FD9A),fontSize:30,fontWeight:FontWeight.w400,letterSpacing: 2)),),
          centerTitle: true,
          backgroundColor: Colors.black,
          actions: <Widget>[
          PopupMenuButton(
            color:Colors.tealAccent[400],
            itemBuilder: (BuildContext context){
              return[
                PopupMenuItem(
                  child: Center(
                    child: FlatButton(
                      onPressed:()async{
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.clear();
                        signOutGoogle();
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Login()),ModalRoute.withName('homepage'));
                      },
                      child: Text('Logout',style:GoogleFonts.orbitron(textStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize:18))),
                      color: Colors.teal,
                      splashColor: Colors.tealAccent,
                    ),
                  )                
                )
              ];
            },
          )
        ],        
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('games').document(widget.post.slug).collection('posts').document(widget.post.postId).collection("comments")
                    .orderBy('date',descending:true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  List<DocumentSnapshot> docs = snapshot.data.documents;

                  List<Widget> messages = docs
                      .map((doc) => Message(
                            message: doc.data['text'],
                            gamerTag: doc.data['from'],
                          ))
                      .toList();

                  return ListView(
                    controller: scrollController,
                    children: <Widget>[
                      ...messages,
                    ],
                  );
                },
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom:10.0,left: 8),
                      child: TextField(
                        onSubmitted: (value) => callback(),
                        decoration: InputDecoration(
                          hoverColor: Colors.deepPurpleAccent,
                          hintText: "Enter a comment",
                          hintStyle: TextStyle(color:Color(0xffE6BBFC)),
                          border: const OutlineInputBorder(),
                        ),
                        controller: messageController,
                      ),
                    ),
                  ),
                  SendButton(
                    text: "Send",
                    callback: callback,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class SendButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  const SendButton({Key key, this.text, this.callback}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.send,size: 33,),
      color: Color(0xffFF16CD),
      onPressed: callback,
    );
  }
}

class Message extends StatefulWidget {
  final String message;
  final String gamerTag;
  Message({@required this.message,@required this.gamerTag});

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  @override

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: 24,
          right: 0),
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(
            top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomRight: Radius.circular(23)),
              gradient: LinearGradient(
              colors: [
                Colors.greenAccent,
                Colors.green[600]
              ],
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.gamerTag,style: TextStyle(color:Colors.black),),
            SizedBox(height:5),
            Text(widget.message,
              textAlign: TextAlign.start,
              style:TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'OverpassRegular',
              fontWeight: FontWeight.w700)
              ),
          ],
        )
      ),
    );
  }
}