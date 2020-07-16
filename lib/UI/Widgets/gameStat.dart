import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:morsey_gaming_social_hub/Models/GameSearchData.dart';
import 'package:morsey_gaming_social_hub/UI/Screens/followingList.dart';

class GameStatsWidget extends StatefulWidget {
  final GameSearch game;
  GameStatsWidget(this.game);
  @override
  _GameStatsWidgetState createState() => _GameStatsWidgetState();
}

class _GameStatsWidgetState extends State<GameStatsWidget> {
  @override
  int count =0;
  bool notAvailable=false;
  Future getPosts()async{
    final x =await Firestore.instance.collection("games").document(widget.game.slug).get();
      if(!x.exists)
        {
          setState(() {
            notAvailable=true;
          });
        }
    return x;
  }
  Future<String> postCount() async{
    final x =await Firestore.instance.collection("games").document(widget.game.slug).collection("posts").getDocuments();
    return x.documents.length.toString();
  }
  String followingCount(AsyncSnapshot data){
    List following= data.data["followers"];
      return following.length.toString();
  }
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPosts(),
      builder: (context, snapshot) {
        if(!snapshot.hasData||snapshot.data==null)
          {return Center(child:CircularProgressIndicator());}
        else
        return Container(
          height: 80,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(15.0),
          color: Colors.black,
          child: Row(
            children: [
              Expanded(
              child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    notAvailable?{}:Navigator.of(context).push(MaterialPageRoute(builder: (context){return GameFollowersList(snapshot.data["followers"]);}));
                  },
                  child: Text(
                    '${notAvailable?"0":followingCount(snapshot)}',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    notAvailable?{}:Navigator.of(context).push(MaterialPageRoute(builder: (context){return GameFollowersList(snapshot.data["followers"]);}));
                  },
                  child: Text(
                    "Followers",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(
                          color: Color(0xff67FD9A),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                )
              ],
              ),
              ),
          Expanded(
          child: Column(
            children: <Widget>[
              FutureBuilder(
                future: postCount(),
                builder: (context, snapshot) {
                  if(snapshot.hasData)
                  return Text(
                    '${notAvailable?"0":snapshot.data}',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  );
                  else
                   return Text('');
                }
              ),
              Text(
                "Posts",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(
                      color: Color(0xff67FD9A),
                      fontWeight: FontWeight.bold,
                    ),
              )
            ],
          ),
          ),
            ],
          )
        );
      }
    );
  }
}