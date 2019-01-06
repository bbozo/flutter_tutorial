import 'package:flutter/material.dart';

import './pages/product.dart';

class Products extends StatelessWidget {
  final List<Map> products;
  final Function deleteProduct;

  Products(this.products, {this.deleteProduct}) {
    print("[Products Widget] constructor");
  }

  // Widget _buildProductItem({String text, String imagePath}) {
  Widget _buildProductItem(BuildContext context, int index) {
    Map<String, String> product = products[index];

    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(product['image']),
          Text(product['title']),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text('Details'),
                onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ProductPage(product['title'], product['image']),
                      ),
                    ).then((value) {
                      if(value) {
                        deleteProduct(index);
                      }
                    }),
              ),
            ],
          )
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
