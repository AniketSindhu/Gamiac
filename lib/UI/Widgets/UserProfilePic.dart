  
import 'package:flutter/material.dart';

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
      onTap: () {
      },
    );
  }
}