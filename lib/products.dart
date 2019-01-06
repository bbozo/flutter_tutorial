import 'package:flutter/material.dart';

class Products extends StatelessWidget {
  final List<String> products;

  Products([this.products = const []]) {
    print("[Products Widget] constructor");
  }

  Card _buildProduct({String text, String imagePath}) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(imagePath),
          Text(text),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("[Products Widget] build()");
    return ListView(
      children: products
          .map(
            (element) => _buildProduct(
                text: element, imagePath: 'assets/food.jpeg'),
          )
          .toList(),
    );
  }
}
