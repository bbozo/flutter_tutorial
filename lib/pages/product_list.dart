import 'package:flutter/material.dart';

class ProductListPage extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  ProductListPage(this.products);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        final Map<String, dynamic> product = products[index];
        return ListTile(
          // leading: Image.asset(product['image']),
          title: Text(product['title']),
          trailing: IconButton(icon: Icon(Icons.edit), onPressed: (){},),
        );
      },
      itemCount: products.length,
    );
  }
}
