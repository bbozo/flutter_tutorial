import 'package:flutter/material.dart';

import './products.dart';
import './product_control.dart';

class ProductManager extends StatelessWidget {
  final List<Map<String, String>> products;
  final Function addProduct;
  final Function deleteProduct;

  ProductManager(this.products, this.addProduct, this.deleteProduct);

  @override
  Widget build(BuildContext context) {
    // NOTE: Products returns a ListView, a ListView can't be used below another widget
    // (the container with the button/ProductController). We wrap the Products ListView into
    // a container of it's own. Container is fixed in size, Expandable is the way to go.    
    return Column(
      children: [
        Container(
          child: ProductControl(addProduct),
          margin: EdgeInsets.all(10.0),
        ),
        Expanded(
          child: Products(products, deleteProduct: deleteProduct)
        ) // Expanded is a container that expands to full size
      ],
    );
  }

}