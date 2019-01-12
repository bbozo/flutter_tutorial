import 'package:flutter/material.dart';
import 'package:flutter_tutorial/pages/product_edit.dart';

class ProductListPage extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final Function updateProduct;

  ProductListPage(this.products, this.updateProduct);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        final Map<String, dynamic> product = products[index];
        return ListTile(
          // leading: Image.asset(product['image']),
          title: Text(product['title']),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ProductEditPage(
                    product: product, updateProduct: updateProduct, productIndex: index);
              }));
            },
          ),
        );
      },
      itemCount: products.length,
    );
  }
}
