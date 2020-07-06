import 'package:flutter/material.dart';
import 'ui/Screens/Hompage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ui/Screens/Login.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool login=prefs.getBool('login');
  runApp(login==null?MyApp1():login?MyApp2():MyApp1());
}

class MyApp1 extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Morsey',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:Login(),
      routes: {
        'login':(context)=>Login(),
        'homepage':(context)=>HomePage()
      },
    );
  }
}

class MyApp2 extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Morsey',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:HomePage(),
      routes: {
        'login':(context)=>Login(),
        'homepage':(context)=>HomePage()
      },
    );
  }
}