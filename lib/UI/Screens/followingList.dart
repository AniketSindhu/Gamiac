import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:morsey_gaming_social_hub/Models/user.dart';
import 'package:morsey_gaming_social_hub/UI/Screens/profilePage.dart';
import 'package:morsey_gaming_social_hub/UI/Widgets/UserProfilePic.dart';

class FollowingList extends StatefulWidget {
  final String email;
  FollowingList(this.email);
  @override
  _FollowingListState createState() => _FollowingListState();
}

class _FollowingListState extends State<FollowingList> {
  Future getGames()async{
    final x= await Firestore.instance.collection("users").document(widget.email).get();
    List a= x.data['games_followed'];
    return a;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xff21252A),
      appBar:AppBar(
        title:Text("Followed games",style:GoogleFonts.bangers(textStyle:TextStyle(color:Color(0xff67FD9A),fontSize:30,fontWeight:FontWeight.w400,letterSpacing: 2)),),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body:Container(
        margin: EdgeInsets.only(top:20),
        child: FutureBuilder(
          future: getGames(),
          builder:(_,snapshots){
            if(snapshots.connectionState==ConnectionState.waiting){
              return Center(child:Lottie.asset("assets/loading.json"));
            }
            else
            return ListView.builder(
              itemCount: snapshots.data.length,
              itemBuilder:(context,i){
              return Column(
                children: [
                  ListTile(
                    enabled: true,
                    title: Text(snapshots.data[i].toString().replaceAll("-", " "),style: TextStyle(fontWeight:FontWeight.w500,fontSize:17),),
                  ),
                  Divider(color:Colors.grey)
                ],
              );
              } 
            );
          } 
        ),
      )
    );
  }
}

class GameFollowersList extends StatefulWidget {
  final List followers;
  GameFollowersList(this.followers);
  @override
  _GameFollowersListState createState() => _GameFollowersListState();
}

class _GameFollowersListState extends State<GameFollowersList> {
  @override
  List<User> users=[];
  void getUsers() async{
    widget.followers.forEach((element) async {
      final x= await Firestore.instance.collection("users").document(element.toString()).get();
      users.add(User.fromDocument(x));
      setState(() {
      });
    });
  }
  void initState(){
    super.initState();
    getUsers();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xff21252A),
      appBar:AppBar(
        title:Text("Followed games",style:GoogleFonts.bangers(textStyle:TextStyle(color:Color(0xff67FD9A),fontSize:30,fontWeight:FontWeight.w400,letterSpacing: 2)),),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body:Container(
        margin: EdgeInsets.only(top:20),
        child: users!=null?ListView.builder(
              itemCount: users.length,
              itemBuilder:(context,i) {
              return Column(
                children: [
                  ListTile(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder:(context){return ProfilePage(users[i],false);}));
                    },
                    enabled: true,
                    leading: Container(
                      height: 50,
                      width: 50,
                      child: UserProfilePicture(userId: users[i].email,profilePicture: users[i].photoUrl,)),
                    title: Text(users[i].gamer_tag,style: TextStyle(fontWeight:FontWeight.w500,fontSize:17),),
                  ),
                  Divider(color:Colors.grey)
                ],
              );
            } 
          ):Container()
      )
    );
  }
}