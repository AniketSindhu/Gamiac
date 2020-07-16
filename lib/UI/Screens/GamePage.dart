import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:morsey_gaming_social_hub/Methods/GoogleSignIn.dart';
import 'package:morsey_gaming_social_hub/Models/GameSearchData.dart';
import 'package:morsey_gaming_social_hub/Models/user.dart';
import 'package:morsey_gaming_social_hub/UI/Widgets/gameHead.dart';
import 'package:morsey_gaming_social_hub/UI/Widgets/gamePost.dart';
import 'package:morsey_gaming_social_hub/UI/Widgets/gameStat.dart';
import 'package:morsey_gaming_social_hub/UI/Widgets/profHead.dart';
import 'package:morsey_gaming_social_hub/UI/Widgets/profilePost.dart';
import 'package:morsey_gaming_social_hub/UI/Widgets/stat.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login.dart';

class GamePage extends StatefulWidget {
  final GameSearch game;
  final User user;
  GamePage(this.game,this.user);
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom:30),
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
        color: Color(0xff21252A),
        child: Column(
          children:<Widget>[
            GameHeader(user: widget.user,game:widget.game),
            GameStatsWidget(widget.game),
            GamePostsWidget(game: widget.game,),
          ]
        ),
        )
      ),
    );
  }
}