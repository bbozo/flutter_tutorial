import 'package:flutter/material.dart';

class Products extends StatelessWidget {
  final List<String> products;

  Products([this.products = const []]) {
    print("[Products Widget] constructor");
  }

  // Widget _buildProductItem({String text, String imagePath}) {
  Widget _buildProductItem(BuildContext context, int index) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset('assets/food.jpeg'),
          Text(products[index]),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    Widget productCard =
        Center(child: Text("No products found, please add some"));

    if (products.length > 0)
      productCard = ListView.builder(
        itemBuilder: _buildProductItem,
        itemCount: products.length,
      );

    return productCard;
  }

  @override
  Widget build(BuildContext context) {
    print("[Products Widget] build()");
    return _buildProductList();
  }
}
