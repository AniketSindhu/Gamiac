import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:morsey_gaming_social_hub/Methods/GoogleSignIn.dart';
import 'package:morsey_gaming_social_hub/Models/GameSearchData.dart';
import 'package:morsey_gaming_social_hub/Models/user.dart';
import 'package:morsey_gaming_social_hub/UI/Screens/GamePage.dart';
import 'package:morsey_gaming_social_hub/UI/Screens/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  final User user;
  SearchPage(this.user);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List <GameSearch>searchList;
  String query='';
  final _debouncer = Debouncer(milliseconds: 500);
  fetchSearchList() async {
    final response = await http.get('https://api.rawg.io/api/games?page_size=8&search=${query.replaceAll(' ', '%20')}');
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value){
                  setState(() {
                    query=value;
                  });                  
                  _debouncer.run(() {
                    fetchSearchList();                   
                  });
                },
                decoration:InputDecoration(
                  enabledBorder:OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(12)),borderSide: BorderSide(color:Colors.redAccent)),
                  hintText:'Search Any Game',hintStyle: TextStyle(color:Colors.red,fontWeight:FontWeight.w600)),
              )
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 300),
                itemCount: searchList==null?0:searchList.length,
                itemBuilder: (context,index){
                  return  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder:(context){return GamePage(searchList[index], widget.user);}));
                    },
                    child: Card(
                      elevation: 10,
                      shadowColor: Colors.teal,
                      color: Colors.grey[900],
                      child:Stack(
                        children:<Widget>[
                          Center(child: Image.network(searchList[index].image,fit: BoxFit.fitWidth,)),
                          Text("${searchList[index].name}",style: TextStyle(fontSize:20),textAlign: TextAlign.center,)
                          ]
                      )
                    ),
                  );
                },
              ),
            )
        ],
      ),
      backgroundColor: Color(0xff21252A),
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
