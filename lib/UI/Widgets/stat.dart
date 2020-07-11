import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StatsWidget extends StatefulWidget {
  final String email;
  StatsWidget(this.email);
  @override
  _StatsWidgetState createState() => _StatsWidgetState();
}

class _StatsWidgetState extends State<StatsWidget> {
  @override
  int count =0;
  Future getPosts()async{
    final x =await Firestore.instance.collection("users").document(widget.email).get();
    return x;
  }
  Future<String> postCount() async{
    final x =await Firestore.instance.collection("users").document(widget.email).collection("userPosts").getDocuments();
    return x.documents.length.toString();
  }
  String followingCount(AsyncSnapshot data){
    List following= data.data["games_followed"];
      return following.length.toString();
  }
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPosts(),
      builder: (context, snapshot) {
        if(!snapshot.hasData)
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
                Text(
                  '${followingCount(snapshot)}',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  "Following",
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
          Expanded(
          child: Column(
            children: <Widget>[
              FutureBuilder(
                future: postCount(),
                builder: (context, snapshot) {
                  if(snapshot.hasData)
                  return Text(
                    '${snapshot.data}',
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