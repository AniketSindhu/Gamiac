  
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:morsey_gaming_social_hub/Models/user.dart';
import 'package:morsey_gaming_social_hub/UI/Screens/profilePage.dart';

class UserProfilePicture extends StatelessWidget {
  final String profilePicture;
  final String userId;
  const UserProfilePicture({Key key,@required this.profilePicture,@required this.userId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color:Color(0xff67FD9A), width: 3),
        ),
        child: CircleAvatar(
          backgroundImage: profilePicture!=null?NetworkImage(profilePicture):AssetImage('assets/pro-gamer.png'),
          backgroundColor: Colors.white,
        ),
      ),
      onTap: () async{
        final x= await Firestore.instance.collection("users").document(userId).get();
        Navigator.of(context).push(MaterialPageRoute(builder:(context){return ProfilePage(User.fromDocument(x),false);}));
      },
    );
  }
}