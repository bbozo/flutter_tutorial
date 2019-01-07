import 'package:flutter/material.dart';
import 'dart:async';

class ProductPage extends StatelessWidget {
  final String title;
  final String imageUrl;

  ProductPage(this.title, this.imageUrl);

  void _showWarningDialogue(BuildContext context) {
    showDialog(
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text('This action can not be reversed.'),
            actions: <Widget>[
              FlatButton(
                  child: Text('DISCARD'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              FlatButton(
                  child: Text('CONTINUE'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context, true);
                  }),
            ],
          );
        },
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print('Back button pressed');
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Product Detail')),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/food.jpeg'),
            Container(padding: EdgeInsets.all(10.0), child: Text('Details!')),
            Container(
                padding: EdgeInsets.all(10.0),
                child: RaisedButton(
                  color: Theme.of(context).accentColor,
                  child: Text('DELETE'),
                  onPressed: () => _showWarningDialogue(context),
                ))
          ],
        ),
      ),
    );
  }
}
