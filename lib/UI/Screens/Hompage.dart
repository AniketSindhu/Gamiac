import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:morsey_gaming_social_hub/Methods/GoogleSignIn.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Login.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(
          title:Text('Morsey'),
          centerTitle: true,
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
        backgroundColor: Color(0xff1B0536),
        body: Center(child: Column(
          children: <Widget>[
            Text("yo"),
            SizedBox(height:10),
          ],
        ),),
    );
  }
}