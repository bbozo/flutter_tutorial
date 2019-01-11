import 'package:flutter/material.dart';

class Products extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  Products(this.products) {
    print("[Products Widget] constructor");
  }

  // Widget _buildProductItem({String text, String imagePath}) {
  Widget _buildProductItem(BuildContext context, int index) {
    Map<String, dynamic> product = products[index];

    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(product['image']),
          Padding(
            padding: EdgeInsets.only(top: 10.00),
            child: Text(product['title']),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text('Details'),
                onPressed: () => Navigator.pushNamed<bool>(
                    context, '/product/' + index.toString()),
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
