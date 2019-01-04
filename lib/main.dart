import 'package:flutter/material.dart';
import 'package:flutter_tutorial/products.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  List<String> _products = ['Food Tester'];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: Text('EasyList')),
            body: Column(children: <Widget>[
              Container(
                child: RaisedButton(
                  child: Text("Add Product"),
                  onPressed: () {
                    setState(() {
                      _products.add("wiii");
                    });
                  },
                ),
                margin: EdgeInsets.all(10.0),
              ),
              Products(_products)
            ])));
  }
}
