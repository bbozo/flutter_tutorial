import 'package:flutter/material.dart';

class Products extends StatelessWidget {
  final List<String> products;

  Products([this.products = const []]) {
    print("[Products Widget] constructor");
  }

  Card _singleProductConstructor({String text, String imagePath}) {
    return Card(
      child: Column(
        children: <Widget>[
          // Image.asset(imagePath),
          Text(text),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("[Products Widget] build()");
    return Column(
      children: products
          .map(
            (element) => _singleProductConstructor(
                text: element, imagePath: 'assets/food.jpeg'),
          )
          .toList(),
    );
  }
}
