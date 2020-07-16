import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:morsey_gaming_social_hub/Models/GameSearchData.dart';
import 'package:morsey_gaming_social_hub/Models/post.dart';
import 'package:morsey_gaming_social_hub/UI/Screens/SinglePost.dart';

class GamePostsWidget extends StatefulWidget {
  final GameSearch game;
  const GamePostsWidget({
    Key key,
    @required this.game,
  }) : super(key: key);

  @override
  _GamePostsWidgetState createState() => _GamePostsWidgetState();
}

class _GamePostsWidgetState extends State<GamePostsWidget> {
  @override
  Future getPosts()async{
    final x =await Firestore.instance.collection("games").document(widget.game.slug).collection("posts").orderBy("timestamp",descending: true).getDocuments();
    return x.documents;
  }
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPosts(),
      builder: (context, snapshot) {
        if(!snapshot.hasData)
        {
          return Center(child: Lottie.asset("assets/loading.json"));
        }
        else if(snapshot.data.length==0)
          {
            return Center(
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height:45),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("No post related to the game",style: TextStyle(color:Colors.white,fontSize: 18,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                  ),
                ],
            ));
          }
        return Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            children: <Widget>[
              Divider(),
              GridView.builder(
                itemCount: snapshot.data.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 11.0,
                    mainAxisSpacing: 11.0),
                itemBuilder: (ctx, i) {
                  return GestureDetector(
                    onTap: () {
                       Navigator.of(context).push(MaterialPageRoute(builder: (context){return SinglePost(Post.fromDocument(snapshot.data[i]));}));
                    },
                    child: Image.network(
                      "${snapshot.data[i].data["mediaUrl"]}",
                      fit: BoxFit.cover,
                    ),
                  );
                },
              )
            ],
          ),
        );
      }
    );
  }
}