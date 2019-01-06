import 'package:flutter/material.dart';

import './products.dart';
import './product_control.dart';

class ProductManager extends StatefulWidget {
  final String startingProduct;

  ProductManager({this.startingProduct}) {
    print("[ProductManager Widget] constructor");
  }

  @override
  State<StatefulWidget> createState() {
    print("[ProductManager Widget] createState()");
    return _ProductManagerState();
  }
}

class _ProductManagerState extends State<ProductManager> {
  List<String> _products = [];

  @override
  void initState() {
    print("[_ProductManagerState Widget] initState()");
    if(widget.startingProduct != null)
      _products.add(widget.startingProduct);

    super.initState(); // called in the end
  }

  @override
  void didUpdateWidget(ProductManager oldWidget) {
    print("[_ProductManagerState Widget] didUpdateWidget()");
    super.didUpdateWidget(oldWidget);
  }

  void _addProduct(String product) {
    setState(() {
      _products.add(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    // NOTE: Products returns a ListView, a ListView can't be used below another widget
    // (the container with the button/ProductController). We wrap the Products ListView into
    // a container of it's own. Container is fixed in size, Expandable is the way to go.    
    return Column(
      children: [
        Container(
          child: ProductControl(_addProduct),
          margin: EdgeInsets.all(10.0),
        ),
        Expanded(
          child: Products(_products)
        ) // Expanded is a container that expands to full size
      ],
    );
  }
}
