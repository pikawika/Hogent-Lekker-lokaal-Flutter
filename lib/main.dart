import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'pages/login/login_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context)=>LoginPage(),
    HomePage.tag: (context)=>HomePage(),
  };

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Lekker Lokaal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        fontFamily: 'Nunito',
      ),
      home: LoginPage(),
      routes: routes
    );
  }
}