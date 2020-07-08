import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatefulWidget {
  final DocumentSnapshot snapshot;

  const ProfileHeader({Key key, @required this.snapshot}) : super(key: key);
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
              itemCount: 2,
              itemBuilder: (ctx, i) {
                return Image.network(
                  "${widget.snapshot.data['profile_pic']}",
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 15.0, vertical: 11.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(.3),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.chevron_left,
                        color: Color(0xff67FD9A),
                      ),
                      onPressed: () {
                      },
                    ),
                  ),
                  Text(
                    "${widget.snapshot.data['gamer_tag']}",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  CircleAvatar(
                    backgroundImage: widget.snapshot.data['profile_pic']==null?Image.asset('assets/pro-gamer.png'):NetworkImage(
                      "${widget.snapshot.data['profile_pic']}",
                    ),
                  ),
                ],
              ),
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
                        Row(
                          children: <Widget>[
                            Text(
                              "EPIC GAMER",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(
                                    color: Color(0xff67FD9A),
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            SizedBox(width: 15),
                          ],
                        ),
                        Text(
                          "${widget.snapshot.data['name']}",
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
                                  "Follow",
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      .copyWith(
                                          fontWeight:
                                              FontWeight.bold),
                                ),
                                onPressed: () {},
                                color: Color(0xff67FD9A),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(25.0),
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding:
                                    const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey[200],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.more_vert,
                                  color: Color(0xff67FD9A),
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