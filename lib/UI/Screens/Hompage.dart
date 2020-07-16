import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:morsey_gaming_social_hub/Methods/GoogleSignIn.dart';
import 'package:morsey_gaming_social_hub/Models/user.dart';
import 'package:morsey_gaming_social_hub/UI/Screens/News.dart';
import 'package:morsey_gaming_social_hub/UI/Screens/UploadPage.dart';
import 'package:morsey_gaming_social_hub/UI/Screens/profilePage.dart';
import 'package:morsey_gaming_social_hub/UI/Screens/searchPage.dart';
import 'package:morsey_gaming_social_hub/UI/Widgets/profHead.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'Login.dart';
import 'feed.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String email;
  int page;
  int bottomSelectedIndex;
  User user1;
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

getEmail()async{
     FirebaseAuth auth=FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    email = user.email;
    final x=await Firestore.instance.collection('users').document(email).get();
    user1 = User.fromDocument(x);
    setState(() {
      
    });
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }
  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }
  @override
  void initState(){
    super.initState();
    getEmail();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.fixedCircle,
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.search, title: 'Search'),
          TabItem(icon: Icons.add, title: 'Add'),
          TabItem(icon: Icons.featured_play_list, title: 'News'),
          TabItem(icon: Icons.people, title: 'Profile'),
        ],
        initialActiveIndex: 0,//optional, default as 0
        onTap: (int index){
          bottomTapped(index);
        },
        color: Color(0xff67FD9A),
        backgroundColor: Colors.black,
        activeColor: Colors.redAccent,
      ),
        body:PageView(
          controller: pageController,
          physics: new NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            pageChanged(index);
          },
          children:<Widget>[
            Feed(),
            SearchPage(user1),
            Upload(currentUser: user1),
            NewsPage(),
            ProfilePage(user1,true)
          ],
        ),
    );
  }
}