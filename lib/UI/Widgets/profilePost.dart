import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ProfilePostsWidget extends StatefulWidget {
  final String email;
  const ProfilePostsWidget({
    Key key,
    @required this.email,
  }) : super(key: key);

  @override
  _ProfilePostsWidgetState createState() => _ProfilePostsWidgetState();
}

class _ProfilePostsWidgetState extends State<ProfilePostsWidget> {
  @override
  Future getPosts()async{
    final x =await Firestore.instance.collection("users").document(widget.email).collection("userPosts").getDocuments();
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
                    onTap: () {},
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