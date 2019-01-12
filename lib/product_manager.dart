import 'package:flutter/material.dart';
import 'package:flutter_tutorial/widgets/product/products.dart';


class ProductManager extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  ProductManager(this.products);

  @override
  Widget build(BuildContext context) {
    // NOTE: Products returns a ListView, a ListView can't be used below another widget
    // (the container with the button/ProductController). We wrap the Products ListView into
    // a container of it's own. Container is fixed in size, Expandable is the way to go.    
    return Column(
      children: [
        Expanded(
          child: Products(products)
        ) // Expanded is a container that expands to full size
      ],
    );
  }

}