import 'package:flutter/material.dart';
import 'package:flutter_tutorial/widgets/product/product_card.dart';

class Products extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  Products(this.products) {
    print("[Products Widget] constructor");
  }

  Widget _buildProductList() {
    Widget productCard =
        Center(child: Text("No products found, please add some"));

    if (products.length > 0)
      productCard = ListView.builder(
        itemBuilder: (BuildContext context, int index) => ProductCard(index, products[index]),
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

