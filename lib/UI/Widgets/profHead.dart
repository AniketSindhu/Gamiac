import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:morsey_gaming_social_hub/Models/user.dart';

class ProfileHeader extends StatefulWidget {
  final User user;
  final bool isOwn;
  const ProfileHeader({Key key, @required this.user,this.isOwn}) : super(key: key);
  @override
  _ProfileHeaderState createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
   File _image;
  int _currentCoverIndex = 0;
  
  void ChangePhoto() async{
  final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile.path);
    });
    if(_image!=null){
       String _uploadedFileURL;
       String fileName = "ProfilePics/${widget.user.email}";
       StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
       StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
       StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
       print(taskSnapshot);
       await firebaseStorageRef.getDownloadURL().then((fileURL) async {
        _uploadedFileURL = fileURL;
       });
       Firestore.instance.collection('users').document(widget.user.email).setData({'profile_pic':_uploadedFileURL},merge: true).whenComplete((){
        FlutterToast.showToast(  
          msg: "Image uploaded",   
          backgroundColor: Colors.green,  
          textColor: Colors.white,  
          fontSize: 16.0  
          );
          setState(() {
            
          });
       });      
    }
  else
    FlutterToast.showToast(  
      msg: "No image selected",   
      backgroundColor: Colors.red,  
      textColor: Colors.white,  
      fontSize: 16.0  
    );
}

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
                return _image==null?widget.user.photoUrl==null?Image.asset('assets/pro-gamer.png',fit: BoxFit.fill,):Image.network(
                      "${widget.user.photoUrl}",fit: BoxFit.fill,):Image.file(_image,fit: BoxFit.fill,);
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
                              child: widget.isOwn?RaisedButton(
                                child: Text(
                                  "Change photo",
                                  style: TextStyle(fontWeight:FontWeight.bold,fontSize: 15,color: Colors.redAccent)
                                ),
                                onPressed: () {
                                  ChangePhoto();
                                },
                                color: Color(0xff67FD9A),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(25.0),
                                ),
                              ):Container(),
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

