import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:morsey_gaming_social_hub/Methods/GoogleSignIn.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:morsey_gaming_social_hub/Config/size.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  bool checked=false;
  Widget build(BuildContext context) {
    double height=SizeConfig.getHeight(context);
    double width=SizeConfig.getWidth(context);
    return Scaffold(
      backgroundColor:Color(0xff21252A),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:<Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Text('GAMIAC',style: GoogleFonts.orbitron(textStyle:TextStyle(color:Color(0xff67FD9A),fontSize:40,fontWeight: FontWeight.bold)),)),
          Text('Social Hub For Gamers',style: TextStyle(color: Colors.tealAccent),),
          SizedBox(height:30),
          Container(
            child: Center(child: Lottie.asset('assets/loginAnim.json')),
            height:height/2.5,
            width: width*0.95,
          ),
          SizedBox(height:10),
          SignInButton(Buttons.GoogleDark,
            onPressed: (){
              if(checked==true)
                signInWithGoogle(context);
              else
               FlutterToast.showToast(
                 msg: "Please review privacy policy first",
                backgroundColor: Colors.redAccent,
                textColor: Colors.white
              );
            },
            text: 'Continue With Google',),
          SizedBox(height:10),
          CheckboxListTile(
            title: Text.rich(TextSpan(
              children:[
                TextSpan(text:"You accept the"),
                TextSpan(text:" Privacy policy ",recognizer: TapGestureRecognizer()..onTap=(){
                  launch("https://gamiac.flycricket.io/privacy.html");
                },style: TextStyle(color:Colors.blue,fontStyle: FontStyle.italic)),
                TextSpan(text:"of morsey")
              ] )),
            value: checked,
            onChanged: (newValue) { 
              setState(() {
                   checked = newValue; 
                 }); 
               },
            controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
          )
        ]
      ),
    );
  }
}