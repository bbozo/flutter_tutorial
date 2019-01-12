import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_tutorial/widgets/product/price_tag.dart';

class ProductPage extends StatelessWidget {
  final Map<String, dynamic> product;

  ProductPage(this.product);

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              product['title'],
              style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Oswald'),
            ),
            Container(
              constraints: BoxConstraints.expand(height: 250.0),
              margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(product['image']), fit: BoxFit.cover)),
              child: Stack(
                children: <Widget>[
                  Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton(
                        icon: Icon(Icons.delete_outline),
                        color: Colors.grey,
                        iconSize: 35,
                        onPressed: () => _showWarningDialogue(context),
                      )),
                  Positioned(
                    left: 0.0,
                    bottom: 0.0,
                    child: Padding(
                      child: PriceTag(product['price']),
                      padding: EdgeInsets.all(10.00),
                    ),
                  ),
                  Positioned(
                    right: 0.0,
                    bottom: 0.0,
                    child: IconButton(
                      icon: Icon(Icons.favorite_border),
                      color: Colors.red,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey, width: 2.0),
              ),
              padding: EdgeInsets.all(10.0),
              child: Text(
                product['address'],
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Text(
                product['details'],
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
