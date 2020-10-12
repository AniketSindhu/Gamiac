import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:morsey_gaming_social_hub/Methods/GoogleSignIn.dart';
import 'package:morsey_gaming_social_hub/UI/Screens/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart'as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:auto_size_text/auto_size_text.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  static const String feedUrl='https://www.pcgamer.com/rss/';
  RssFeed _feed;
  String _title;
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  updateFeed(feed){
    if(mounted)
    setState(() {
      _feed=feed;
    });
  }
  load() async{
    loadfeed().then((value){
      if(value==null)
        {
          FlutterToast.showToast(  
              msg: "Something went wrong try again",   
              backgroundColor: Colors.red,  
              textColor: Colors.white,  
              fontSize: 16.0  
            );
        }
        updateFeed(value);
    });
  }
  Future<RssFeed> loadfeed()async{
    try{
      final client=http.Client();
      final response= await client.get(feedUrl);
      return RssFeed.parse(response.body);
    }catch(e){

    }
    return null;
  }
  void initState(){
    super.initState();
    load();
  }
  title(title){
    return AutoSizeText(title,style: GoogleFonts.ptSerif(color:Colors.white,fontSize:22,fontWeight:FontWeight.w500),maxLines: 2,overflow: TextOverflow.ellipsis,);
  }
  thumbnail(url){
    return Container(
      decoration: BoxDecoration(
        borderRadius:BorderRadius.only(topLeft:Radius.circular(18),
        topRight:Radius.circular(18),),
        image: DecorationImage(image: CachedNetworkImageProvider(url 
      ), )
      ),
    );
  }
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: _feed!=null?ListView.builder(
      itemCount: _feed.items.length,
      itemBuilder: (BuildContext context,index){
        final item=_feed.items[index];
        return GestureDetector(
          onTap: (){
            launch(item.link,forceSafariVC: true,forceWebView: true);
          },
          child: Container(
            margin: EdgeInsets.only(bottom:7),
            height: MediaQuery.of(context).size.height/2.5,
            width: MediaQuery.of(context).size.width,
            child: Card(
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child:Column(children: [
                Container(
                  height:MediaQuery.of(context).size.height/3.5,
                  child: thumbnail(item.media.contents[0].url),
                ),
                Expanded(
                  child: Padding(
                  padding: EdgeInsets.all(10),
                   child:title(item.title))
                )
              ],)
            ),
          ),
        );
      }
      ):Center(child:Lottie.asset('assets/loading.json'))
    );
  }
}