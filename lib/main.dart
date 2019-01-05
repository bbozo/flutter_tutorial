import 'package:flutter/material.dart';
import './product_manager.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: Text('EasyList')),
            body: Column(children: <Widget>[
              ProductManager(startingProduct: "Food Tester"),
            ])),
        theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            accentColor: Colors.deepPurple,
            brightness: Brightness.light));
  }
}
