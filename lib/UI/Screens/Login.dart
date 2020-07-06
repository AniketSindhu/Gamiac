import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:morsey_gaming_social_hub/Methods/GoogleSignIn.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:morsey_gaming_social_hub/Config/size.dart';
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    double height=SizeConfig.getHeight(context);
    double width=SizeConfig.getWidth(context);
    return Scaffold(
      backgroundColor: Color(0xff1B0536),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:<Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Text('MORSEY',style: GoogleFonts.orbitron(textStyle:TextStyle(color:Colors.tealAccent,fontSize:40,fontWeight: FontWeight.bold)),)),
          Text('Social Hub For Gamers',style: TextStyle(color: Colors.tealAccent),),
          SizedBox(height:30),
          Container(
            child: Center(child: Lottie.asset('assets/loginAnim.json')),
            height:height/2.5,
            width: width*0.95,
          ),
          SizedBox(height:10),
          SignInButton(Buttons.GoogleDark, onPressed: ()=>signInWithGoogle(context),text: 'Continue With Google',)
        ]
      ),
    );
  }
}