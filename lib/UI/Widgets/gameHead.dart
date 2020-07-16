import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:morsey_gaming_social_hub/Models/GameSearchData.dart';
import 'package:morsey_gaming_social_hub/Models/user.dart';

class GameHeader extends StatefulWidget {
  final GameSearch game;
  final User user;
  const GameHeader({Key key, @required this.game,this.user}) : super(key: key);
  @override
  _GameHeaderState createState() => _GameHeaderState();
}

class _GameHeaderState extends State<GameHeader> {
int _currentCoverIndex = 0;
bool followed=false;
 @override
 Future isFollow() async{
   final x= await Firestore.instance.collection("users").document(widget.user.email).get();
   List z=x.data["games_followed"];
   if(z.contains(widget.game.slug))
    {
      setState(() {
        followed=true;
      });
    }
    else
      setState(() {
        followed=false;
      });
 } 
 follow()async{
   final x= await Firestore.instance.collection("games").document(widget.game.slug).get();
   if(x.exists)
    {
      final z= await Firestore.instance.collection("users").document(widget.user.email).get();
        List l=z.data["games_followed"];
        if(l.contains(widget.game.slug))
          { 
            followed=false;
            await Firestore.instance.collection("users").document(widget.user.email).updateData({"games_followed":FieldValue.arrayRemove([widget.game.slug])});
            final f=await Firestore.instance.collection("users").document(widget.user.email).collection("feed").where("slug",isEqualTo:widget.game.slug).getDocuments();
            f.documents.forEach((element) {
                 Firestore.instance.collection("users").document(widget.user.email).collection("feed").document(element.documentID).delete();
            });
            await Firestore.instance.collection("games").document(widget.game.slug).updateData({"followers_count":FieldValue.increment(-1),"followers":FieldValue.arrayRemove([widget.user.email])});
            setState(() {});
          }
        else{
          followed=true;
          await Firestore.instance.collection("users").document(widget.user.email).updateData({"games_followed":FieldValue.arrayUnion([widget.game.slug])});
          await Firestore.instance.collection("games").document(widget.game.slug).updateData({"followers":FieldValue.arrayUnion([widget.user.email]),"followers_count":FieldValue.increment(1)});
          final o=await Firestore.instance.collection("games").document(widget.game.slug).collection("posts").getDocuments();
           o.documents.forEach((element) {
             Firestore.instance.collection("users").document(widget.user.email).collection("feed").document(element.documentID).setData(element.data);
           });
          setState(() {});
        }
    }
    else{
      setState(() {
        followed=true;
      });
      await Firestore.instance.collection('games').document(widget.game.slug).setData({'followers':[widget.user.email],'followers_count':1,'slug':widget.game.slug});
      await Firestore.instance.collection('users').document(widget.user.email).updateData({'games_followed':FieldValue.arrayUnion([widget.game.slug])});
    }
 }
  @override
  void initState(){
    super.initState();
    isFollow();
  }
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: PageView.builder(
              onPageChanged: (i) {
                setState(() {
                  _currentCoverIndex = i;
                });
              },
              itemCount: 3,
              itemBuilder: (ctx, i) {
                return Image.network(
                      "${widget.game.image}",fit: BoxFit.fill,);
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(.5),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "${widget.game.name}",
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: RaisedButton(
                                child: Text(
                                  followed?"Following":"Follow",
                                  style: TextStyle(fontWeight:FontWeight.bold,fontSize: 15,color: Colors.redAccent)
                                ),
                                onPressed: () {follow();},
                                color: Color(0xff67FD9A),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(25.0),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.end,
                                children: List.generate(
                                    3,
                                    (f) {
                                  return Container(
                                    height: 9,
                                    width: 9,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 3.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          _currentCoverIndex == f
                                              ? Color(0xff67FD9A)
                                              : Colors.white,
                                    ),
                                  );
                                }),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}