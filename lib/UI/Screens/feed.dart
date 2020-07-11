import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:morsey_gaming_social_hub/Methods/GoogleSignIn.dart';
import 'package:morsey_gaming_social_hub/Models/post.dart';
import 'package:morsey_gaming_social_hub/Models/user.dart';
import 'package:morsey_gaming_social_hub/UI/Widgets/feedPost.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Login.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  User user1;
  getEmail()async{
     FirebaseAuth auth=FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    email = user.email;
    final x=await Firestore.instance.collection('users').document(email).get();
    user1 = User.fromDocument(x);
    setState(() {     
    });
  }
  

  @override
  void initState(){
    super.initState();
    getEmail();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff21252A),
      body: CustomScrollView(
        slivers:<Widget>[
          SliverAppBar(
            elevation: 10,
            expandedHeight: 150,
            pinned: true,
            floating: true,
            centerTitle: true,
            backgroundColor: Colors.black,
            actions: [
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
            flexibleSpace: FlexibleSpaceBar(
              background:Image.asset('assets/1.jpg',fit: BoxFit.fill,),
              centerTitle: true,
              title: Text("GAMIAC",style:GoogleFonts.bangers(textStyle:TextStyle(color:Color(0xff67FD9A),fontSize:30,fontWeight:FontWeight.w400,letterSpacing: 2)),),
            ),
          ),
          if(user1!=null)
          StreamBuilder(
            stream: Firestore.instance.collection("users").document(user1.email).collection("feed").orderBy('timestamp',descending:true).limit(45).snapshots(),
            builder: (_,snapshot){
              if(snapshot.connectionState==ConnectionState.waiting||!snapshot.hasData){
                return SliverFillRemaining(child: Center(child: Lottie.asset("assets/loading.json")));
              }
              else{
                if(snapshot.data.documents.length==0)
                  {
                    return SliverFillRemaining(
                      child:Text('no posts')
                    );
                  }
                else
                return SliverList(                  
                  delegate:
                    SliverChildBuilderDelegate((_,index){
                      return FeedPost(Post.fromDocument(snapshot.data.documents[index]),user1); 
                    },childCount: snapshot.data.documents.length
                  )
                );
              }
            }
          )
        ]
      ),
      
    );
  }
}