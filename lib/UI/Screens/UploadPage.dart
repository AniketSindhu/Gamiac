import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:morsey_gaming_social_hub/Methods/GoogleSignIn.dart';
import 'package:morsey_gaming_social_hub/Models/GameSearchData.dart';
import 'package:morsey_gaming_social_hub/Models/user.dart';
import 'package:morsey_gaming_social_hub/UI/Screens/setScreen.dart';
import 'package:morsey_gaming_social_hub/UI/Widgets/progress.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart'as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Login.dart';

class Upload extends StatefulWidget {
  final User currentUser;
  Upload({@required this.currentUser});
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload>
    with AutomaticKeepAliveClientMixin<Upload> {
  PickedFile file;
  File _image;
  bool isUploading = false;
  String selected;
  String postId = Uuid().v4();
  TextEditingController searchControler = TextEditingController();
  TextEditingController captionControler = TextEditingController();
  List <GameSearch>searchList;
  String query='';
  final _debouncer = Debouncer(milliseconds: 500);

  handleTakePhoto() async {
    Navigator.pop(context);
    PickedFile file = await ImagePicker().getImage(
        source: ImageSource.camera, maxWidth: 960, maxHeight: 1280);
    setState(() {
      this.file = file;
      _image=File(file.path);
    });
  }

  handleChooseFromGallery() async {
    Navigator.pop(context);
    PickedFile file = await ImagePicker().getImage(
        source: ImageSource.gallery, maxWidth: 960, maxHeight: 1280);
    setState(() {
      this.file = file;
      _image=File(file.path);
    });
  }

  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Center(child: Text('Create Post',style: GoogleFonts.bangers(textStyle:TextStyle(color:Colors.black,fontSize:30,fontWeight:FontWeight.w400,letterSpacing: 2)))),
            backgroundColor: Color(0xff67FD9A),
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Photo with Camera',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                onPressed: handleTakePhoto,
              ),
              SimpleDialogOption(
                child: Text('Image from Gallery',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                onPressed: handleChooseFromGallery,
              ),
              SimpleDialogOption(
                child: Text('Cancel',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.redAccent),),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  Container buildSplashScreen() {
    return Container(
      color: Color(0xff21252A),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SvgPicture.asset('assets/upload.svg', height: 260),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: RaisedButton(
              onPressed: () => selectImage(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                'Create post',
                style: TextStyle(color: Colors.white, fontSize: 22.0),
              ),
              color: Colors.redAccent,
            ),
          )
        ],
      ),
    );
  }

  clearImage() {
    setState(() {
      file = null;
    });
  }



  Future<String> uploadImage(imageFile) async {
    StorageUploadTask uploadTask =
        FirebaseStorage.instance.ref().child("post_$postId.jpg").putFile(imageFile);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  createPostInFirestore(
      {String mediaUrl, String slug, String description})async{
      Firestore.instance.collection("users")
        .document(widget.currentUser.email)
        .collection('userPosts')
        .document(postId)
        .setData({
      "postId": postId,
      "ownerEmail": widget.currentUser.email,
      "gamer_Tag": widget.currentUser.gamer_tag,
      "mediaUrl": mediaUrl,
      "description": description,
      "slug": slug,
      "timestamp": DateTime.now(),
      "f": [],
      "rip":[],
      "gg":[]
    });

    final x = await Firestore.instance.collection('games').document(slug).get();
      if(x.exists)
        {
          Firestore.instance.collection('games').document(slug).collection('posts').document(postId)
          .setData({
            "postId": postId,
            "ownerEmail": widget.currentUser.email,
            "gamer_Tag": widget.currentUser.gamer_tag,
            "mediaUrl": mediaUrl,
            "description": description,
            "slug": slug,
            "timestamp": DateTime.now(),
            "owner_pic":widget.currentUser.photoUrl,
            "f": [],
            "rip":[],
            "gg":[]
          }); 
          List a =x.data['followers'];
            a.forEach((element) {
              Firestore.instance.collection('users').document(element).collection('feed').document(postId)
              .setData({
                "postId": postId,
                "ownerEmail": widget.currentUser.email,
                "gamer_Tag": widget.currentUser.gamer_tag,
                "mediaUrl": mediaUrl,
                "description": description,
                "slug": slug,
                "timestamp": DateTime.now(),
                "owner_pic":widget.currentUser.photoUrl,
                "f": [],
                "rip":[],
                "gg":[]
              });               
            });          
        }
        else{
          Firestore.instance.collection('games').document(slug).setData({'followers':[],'followers_count':0,'slug':slug});
          Firestore.instance.collection('games').document(slug).collection('posts').document(postId)
              .setData({
                "postId": postId,
                "ownerEmail": widget.currentUser.email,
                "gamer_Tag": widget.currentUser.gamer_tag,
                "mediaUrl": mediaUrl,
                "description": description,
                "slug": slug,
                "timestamp": DateTime.now(),
                "owner_pic":widget.currentUser.photoUrl,
                "f": [],
                "rip":[],
                "gg":[]
              });                         
        }
  }
  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(_image.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    setState(() {
      _image = compressedImageFile;
    });
  }
  handleSubmit() async {
      if(selected==null||selected=='')
        {
          FlutterToast.showToast(
            msg: "Select a game!",   
            backgroundColor: Colors.red,  
            textColor: Colors.white,  
            fontSize: 16);
        }
    else{
    setState(() {
      isUploading = true;
    });
    await compressImage();
    String mediaUrl = await uploadImage(_image);
    createPostInFirestore(
      mediaUrl: mediaUrl,
      slug: selected,
      description: captionControler.text,
    );
    captionControler.clear();
    searchControler.clear();
    FlutterToast.showToast(
      msg: "Post Uploaded",   
      backgroundColor: Colors.green,  
      textColor: Colors.white,  
      fontSize: 16);
    setState(() {
      file = null;
      isUploading = false;
      selected=null;
      postId = Uuid().v4();
    });
    }
  }

  Scaffold buildUploadForm() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Color(0xff67FD9A),
          onPressed: clearImage,
        ),
        title: Text(
          "Upload Post",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Post',
              style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
            onPressed: isUploading ? null : () => handleSubmit(),
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          isUploading ? linearProgress() : Text(""),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            
            child: Image.file((File(file.path)))
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          ListTile(
            title: Container(
              width: 250.0,
              child: TextField(
                controller: captionControler,
                maxLines: 3,
                decoration: InputDecoration(
                    hintText: 'Write Something', border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.teal)
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.gamepad,
              color: Colors.orange,
              size: 35,
            ),
            title: Container(
              width: 280,
              child: TextField(
                onChanged: (value){
                setState(() {
                    query=value;
                  }); 
                _debouncer.run(() {
                    fetchSearchList();       
                  });
                },
                controller: searchControler,
                decoration: InputDecoration(
                    hintText: 'Which game is this post related to?',hintStyle: TextStyle(color: Colors.teal)),
              ),
            ),
          ),
          Container(
            height: 350.0,
            alignment: Alignment.center,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 300),
              itemCount: searchList==null?0:searchList.length,
              itemBuilder: (context,index){
                return  GestureDetector(
                  onTap: (){
                    FlutterToast.showToast(  
                      msg: "${searchList[index].name} is selected",   
                      backgroundColor: Colors.red,  
                      textColor: Colors.white,  
                      fontSize: 16.0  
                    );
                    setState(() {
                      searchControler.text=searchList[index].name; 
                      selected=searchList[index].slug;
                    });                                      
                  },
                  child: Card(
                    elevation: 10,
                    shadowColor: Colors.teal,
                    color: Colors.deepPurple,
                    child:Stack(
                      children:<Widget>[
                        Center(child: Image.network(searchList[index].image,fit: BoxFit.fitWidth,)),
                        Container(color:Colors.redAccent.withOpacity(selected==searchList[index].slug?0.45:0)),
                        Text("${searchList[index].name}",style: TextStyle(fontSize:20),textAlign: TextAlign.center,)
                        ]
                    )
                  ),
                );
              },
            )
          )
        ],
      ),
    );
  }

fetchSearchList() async {
  final response = await http.get('https://api.rawg.io/api/games?page_size=4&search=${query.replaceAll(' ', '%20')}');
  if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var rest = data['results'] as List;
        setState(() {
          searchList = rest.map<GameSearch>((json) => GameSearch.fromJson(json)).toList();
        });

  } else {
    throw Exception('Failed to load deck');
    }
  }


  get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body:file == null ? buildSplashScreen() : buildUploadForm(),
        backgroundColor: Color(0xff21252A),
        appBar:AppBar(
          title:Text("GAMIAC",style:GoogleFonts.bangers(textStyle:TextStyle(color:Color(0xff67FD9A),fontSize:30,fontWeight:FontWeight.w400,letterSpacing: 2)),),
          centerTitle: true,
          backgroundColor: Colors.black,
          actions: <Widget>[
          PopupMenuButton(
            color:Colors.tealAccent[400],
            itemBuilder: (BuildContext context){
              return[
                PopupMenuItem(
                  child: Center(
                    child: FlatButton(
                      onPressed:()async{
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.clear();
                        signOutGoogle();
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Login()),ModalRoute.withName('homepage'));
                      },
                      child: Text('Logout',style:GoogleFonts.orbitron(textStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize:18))),
                      color: Colors.teal,
                      splashColor: Colors.tealAccent,
                    ),
                  )                
                )
              ];
            },
          )
        ],        
      ),
    );
  }
}