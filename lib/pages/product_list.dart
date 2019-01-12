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

        return Dismissible(
          key: Key(index.toString()),
          background: Container(
            color: Colors.red
          ),
          child: Column(
            children: <Widget>[
              ListTile(
                leading:
                    CircleAvatar(backgroundImage: AssetImage(product['image'])),
                title: Text(product['title']),
                subtitle: Text('\$' + product['price'].toString()),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _productEditAction(context, product, index),
                ),
              ),
              Divider()
            ],
          ),
        );
      },
      itemCount: products.length,
    );
  }

  void _productEditAction(BuildContext context, Map<String, dynamic> product, int index) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ProductEditPage(
          product: product, updateProduct: updateProduct, productIndex: index);
    }));
  }
}
