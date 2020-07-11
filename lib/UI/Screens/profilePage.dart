import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:morsey_gaming_social_hub/Methods/GoogleSignIn.dart';
import 'package:morsey_gaming_social_hub/Models/user.dart';
import 'package:morsey_gaming_social_hub/UI/Widgets/profHead.dart';
import 'package:morsey_gaming_social_hub/UI/Widgets/profilePost.dart';
import 'package:morsey_gaming_social_hub/UI/Widgets/stat.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Login.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  final bool isOwn;
  ProfilePage(this.user,this.isOwn);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
        color: Color(0xff21252A),
        child: Column(
          children:<Widget>[
            ProfileHeader(user: widget.user,isOwn:widget.isOwn),
            StatsWidget(widget.user.email),
            ProfilePostsWidget(email: widget.user.email,),
          ]
        ),
        )
      ),
    );
  }
}