import 'package:flutter/material.dart';

import 'data/database_helper.dart';
import 'pages/bon_page/bon_page.dart';
import 'pages/login/login_page.dart';
import 'pages/scan/scan_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  static final db = new DatabaseHelper();
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context)=>LoginPage(),
    BonPage.tag: (context)=>BonPage(),
    ScanPage.tag: (context)=>ScanPage(),
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