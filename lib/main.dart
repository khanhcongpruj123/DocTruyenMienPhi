import 'package:DocTruyenOnline/detailscreen.dart';
import 'package:DocTruyenOnline/homescreen.dart';
import 'package:DocTruyenOnline/readerscreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
      routes: <String, WidgetBuilder> {
        'detail': (BuildContext context) => DetailScreen(),
        'reader': (BuildContext context) => ReaderScreen(),
      },
    );
  }
}