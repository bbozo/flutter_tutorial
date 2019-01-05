import 'package:flutter/material.dart';

import './products.dart';
import './product_control.dart';

class ProductManager extends StatefulWidget {
  final String startingProduct;

  ProductManager({this.startingProduct = 'Sweets Tester'}) {
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
    _products.add(widget.startingProduct);
    super.initState(); // called in the end
  }

  @override
  void didUpdateWidget(ProductManager oldWidget) {
    print("[_ProductManagerState Widget] didUpdateWidget()");
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    print("[_ProductManagerState Widget] build()");
    return Column(children: [
      Container(
        child: ProductControl(),
        margin: EdgeInsets.all(10.0),
      ),
      Products(_products)
    ]);
  }
}
