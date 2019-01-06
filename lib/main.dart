import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import './product_manager.dart';

void main() {
  // debugPaintSizeEnabled = true;  // shows how and why elements fit together
  // debugPaintBaselinesEnabled = true; // shows baselines of texts, not sure when useful
  // debugPaintPointersEnabled = true;  // shows point-click-gesture events
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowMaterialGrid: true, // shows a grid in which material positions objects
      home: Scaffold(
        appBar: AppBar(title: Text('EasyList')),
        body: ProductManager(startingProduct: "Food Tester"),
      ),
      theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.deepPurple,
          brightness: Brightness.light),
    );
  }
}
