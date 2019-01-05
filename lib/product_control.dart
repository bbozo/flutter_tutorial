import 'package:flutter/material.dart';

class ProductControl extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text("Add Product"),
      onPressed: () {
        setState(() {
          _products.add("wiii");
        });
      },
      color: Theme.of(context).primaryColor,
    );
  }
}
