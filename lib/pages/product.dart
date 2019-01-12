import 'package:flutter/material.dart';
import 'package:flutter_tutorial/widgets/product/address_tag.dart';
import 'dart:async';

import 'package:flutter_tutorial/widgets/product/price_tag.dart';
import 'package:flutter_tutorial/widgets/ui_elements/default_title.dart';

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
            DefaultTitle(product['title']),
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
            AddressTag(product['address']),
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
