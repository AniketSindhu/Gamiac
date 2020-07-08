import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:morsey_gaming_social_hub/Globals/Globals.dart' as globals ;
import 'package:morsey_gaming_social_hub/Models/GameSearchData.dart';
import 'package:morsey_gaming_social_hub/Models/post.dart';
import 'package:morsey_gaming_social_hub/UI/Screens/Hompage.dart';
import 'package:http/http.dart'as http;

class setProfile extends StatefulWidget {
  setProfile(this.email);
  final String email;
  @override
  _setProfileState createState() => _setProfileState();
}

class _setProfileState extends State<setProfile> {
  File _image;
  TextEditingController steamController=TextEditingController();
  TextEditingController gamerTagController=TextEditingController();
  checkAuthenticityAndUpload()async{
    final QuerySnapshot result = await Firestore.instance.collection('users').where('gamer_tag',isEqualTo:gamerTagController.text).limit(1).getDocuments();
  
  if(gamerTagController.text.length<2){
    FlutterToast.showToast(  
      msg: "Gamer Tag must be 2 chracter long",   
      backgroundColor: Colors.red,  
      textColor: Colors.white,  
      fontSize: 16.0  
    );
  }
  else if(result.documents.length==1)
    {
      FlutterToast.showToast(  
      msg: "Gamer Tag Already Taken",   
      backgroundColor: Colors.red,  
      textColor: Colors.white,  
      fontSize: 16.0  
      ); 
    }
  else
    {
      if(_image!=null){
       String _uploadedFileURL;
       String fileName = "ProfilePics/${widget.email}";
       StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
       StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
       StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
       print(taskSnapshot);
       await firebaseStorageRef.getDownloadURL().then((fileURL) async {
        _uploadedFileURL = fileURL;
       });
       Firestore.instance.collection('users').document(widget.email).setData({'gamer_Tag':gamerTagController.text,'steam_link':steamController.text,'profile_pic':_uploadedFileURL},merge: true);      
       }
       else{
       Firestore.instance.collection('users').document(widget.email).setData({'gamer_Tag':gamerTagController.text,'steam_link':steamController.text,'profile_pic':null},merge: true);}
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){return SelectGames(widget.email);}));
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1B0536),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
          checkAuthenticityAndUpload();
        },
        child: Icon(Icons.navigate_next,color: Colors.white,), 
        backgroundColor: Colors.teal,
      ),
      appBar: AppBar(
        title:Text("Set Profile",style:GoogleFonts.bangers(textStyle:TextStyle(color:Colors.teal,fontSize:25,fontWeight:FontWeight.bold,letterSpacing: 2)),),
        centerTitle: true,
      ),
        body: new Container(
      child: new ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              new Container(
                height: 250.0,
                child: new Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: new Stack(fit: StackFit.loose, children: <Widget>[
                        new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Container(
                                width: 140.0,
                                height: 140.0,
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                    image:_image!=null?FileImage(File(_image.path)):new ExactAssetImage(
                                        'assets/pro-gamer.png'),
                                    fit: BoxFit.cover,
                                  ),
                                )),
                          ],
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 90.0, right: 100.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new CircleAvatar(
                                  backgroundColor: Colors.red,
                                  radius: 25.0,
                                  child: new IconButton(
                                    onPressed:()async{
                                      final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
                                      setState(() {
                                        _image = File(pickedFile.path);
                                      });
                                    },
                                    icon:Icon(Icons.camera_alt),
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            )),
                      ]),
                    )
                  ],
                ),
              ),
              new Container(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 25.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0,),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'Personal Information',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.teal,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'Gamer Tag',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Flexible(
                                child: new TextField(
                                  controller: gamerTagController,
                                  decoration: const InputDecoration(
                                    hintText: "Enter Your Gamer Tag",
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'Steam Profile link (optional)',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Flexible(
                                child: new TextField(
                                  controller: steamController,
                                  decoration: const InputDecoration(
                                      hintText: "Steam link"),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    )
  );
  }
}


class SelectGames extends StatefulWidget {
  SelectGames(this.email);
  final String email;
  @override
  _SelectGamesState createState() => _SelectGamesState();
}

class _SelectGamesState extends State<SelectGames> {
  List <GameSearch>searchList;
  String query='';
  final _debouncer = Debouncer(milliseconds: 500);
  Future<List<DocumentSnapshot>> getPopGames()async{
    QuerySnapshot games= await Firestore.instance.collection("popular games").getDocuments();
      return games.documents;    
  }
fetchSearchList() async {
  final response = await http.get('https://api.rawg.io/api/games?page_size=4&search=${query.replaceAll(' ', '%20')}');
  if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var rest = data['results'] as List;
        searchList = rest.map<GameSearch>((json) => GameSearch.fromJson(json)).toList();

  } else {
    throw Exception('Failed to load deck');
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed:() async {
          if(globals.gamesSelected.length<=5)
            FlutterToast.showToast(  
              msg: "Select atleast 5 or more games",   
              backgroundColor: Colors.red,  
              textColor: Colors.white,  
              fontSize: 16.0  
            );
            else{
              Firestore.instance.collection('users').document(widget.email).setData({'games_followed':globals.gamesSelected},merge: true);
              for(int i=0;i<globals.gamesSelected.length;i++){
                final x= await Firestore.instance.collection('games').document(globals.gamesSelected[i]).get();
                  if(x.exists)
                    {
                      await Firestore.instance.collection('games').document(globals.gamesSelected[i]).updateData({'followers':FieldValue.arrayUnion([widget.email]),'followers_count':FieldValue.increment(1)});
                      QuerySnapshot y= await Firestore.instance.collection('games').document(globals.gamesSelected[i]).collection('posts').getDocuments();
                      y.documents.forEach((element) {
                        final z= element.data;
                        Firestore.instance.collection('users').document(widget.email).collection('feed').document(z['postId']).setData(z);
                      });
                    }
                  else{
                    await Firestore.instance.collection('games').document(globals.gamesSelected[i]).setData({'followers':[widget.email],'followers_count':1,'slug':globals.gamesSelected[i]});
                  }
              }
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
              globals.gamesSelected.clear();
            }
          },
        child: Icon(Icons.navigate_next,color:Colors.red,size: 40,),
        backgroundColor: Colors.teal,
      ),
      appBar: AppBar(
        title:Text("What Games you like?",style:GoogleFonts.bangers(textStyle:TextStyle(color:Color(0xff67FD9A),fontSize:25,fontWeight:FontWeight.bold,letterSpacing: 2)),),
        centerTitle: true,
      ),
      backgroundColor: Color(0xff21252A),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal:10,vertical:15),
        child:Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value){
                  _debouncer.run(() {
                    setState(() {
                      query=value;
                      fetchSearchList();
                    });                    
                  });
                },
                decoration:InputDecoration(hintText:'Search Any Game')
              )
            ),
            Expanded(
              child: FutureBuilder(
                future: getPopGames(),
                builder: (_,snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting||!snapshot.hasData){
                    return Center(child:CircularProgressIndicator());
                  }
                  else
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 300),
                    itemCount: query==''?snapshot.data.length:searchList.length,
                    itemBuilder: (context,index){
                      return query==''?GameCard(snapshot.data[index]):SearchGameCard(searchList[index]);
                    },
                  );
                }
              ),
            ),
          ],
        )
      ),
    );
  }
}
class GameCard extends StatefulWidget {
  GameCard(this.data);
  final DocumentSnapshot data;
  @override
  _GameCardState createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {
  bool selected=false;
  @override
  void initState(){
    super.initState();
    if(globals.gamesSelected.contains(widget.data['slug']))
      selected=true;
  }
  Widget build(BuildContext context) {
  return GestureDetector(
      onTap: (){
        setState(() {
          selected==true?selected=false:selected=true;
          selected==true?globals.gamesSelected.add(widget.data['slug']):globals.gamesSelected.remove(widget.data['slug']);
          print (globals.gamesSelected);
        });
      },
      child: Card(
      elevation: 10,
      shadowColor: Colors.teal,
      color: Colors.deepPurple,
      child:Stack(
        children:<Widget>[
          Center(child: Image.network(widget.data.data['image'],fit: BoxFit.fitWidth,)),
          Container(
            color:Colors.pink.withOpacity(selected?0.6:0),
            child: selected?Center(child:Icon(Icons.thumb_up,color:Color(0xff67FD9A),size: 35,)):Container(),
          )
        ]
      )
    ),
  );
  }
}

class SearchGameCard extends StatefulWidget {
  SearchGameCard(this.data);
  final GameSearch data;
  @override
  _SearchGameCardState createState() => _SearchGameCardState();
}

class _SearchGameCardState extends State<SearchGameCard> {
  bool selected=false;
  @override
  void initState(){
    super.initState();
    if(globals.gamesSelected.contains(widget.data.slug))
      selected=true;
  }
  Widget build(BuildContext context) {
  return GestureDetector(
      onTap: (){
        setState(() {
          selected==true?selected=false:selected=true;
          selected==true?globals.gamesSelected.add(widget.data.slug):globals.gamesSelected.remove(widget.data.slug);
          print (globals.gamesSelected);
        });
      },
      child: Card(
      elevation: 10,
      shadowColor: Colors.teal,
      color: Colors.deepPurple,
      child:Stack(
        children:<Widget>[
          Center(child: Image.network(widget.data.image,fit: BoxFit.fitWidth,)),
          Align(alignment:Alignment.bottomCenter,child: Text(widget.data.name,style: TextStyle(color:Colors.white,fontSize:18,fontWeight: FontWeight.w500),textAlign: TextAlign.center,)),
          Container(
            color:Colors.pink.withOpacity(selected?0.6:0),
            child: selected?Center(child:Icon(Icons.thumb_up,color:Colors.tealAccent,size: 35,)):Container(),
          )
        ]
      )
    ),
  );
  }
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;
 
  Debouncer({this.milliseconds});
 
  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}