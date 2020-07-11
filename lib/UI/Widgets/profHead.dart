import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:morsey_gaming_social_hub/Models/user.dart';

class ProfileHeader extends StatefulWidget {
  final User user;
  final bool isOwn;
  const ProfileHeader({Key key, @required this.user,this.isOwn}) : super(key: key);
  @override
  _ProfileHeaderState createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {

  int _currentCoverIndex = 0;


  @override
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
                return widget.user.photoUrl==null?Image.asset('assets/pro-gamer.png',fit: BoxFit.fill,):Image.network(
                      "${widget.user.photoUrl}",fit: BoxFit.contain,);
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
                          "${widget.user.gamer_tag}",
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
                                  widget.isOwn?"Edit Profile":"Games",
                                  style: TextStyle(fontWeight:FontWeight.bold,fontSize: 15,color: Colors.redAccent)
                                ),
                                onPressed: () {},
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