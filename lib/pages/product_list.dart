import 'package:flutter/material.dart';
import 'package:flutter_tutorial/models/product.dart';
import 'package:flutter_tutorial/pages/product_edit.dart';

class ProductListPage extends StatelessWidget {
  final List<Product> products;
  final Function updateProduct;
  final Function deleteProduct;

  ProductListPage(this.products, this.updateProduct, this.deleteProduct);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        final Product product = products[index];

        return Dismissible(
          key: Key(product.title),
          background: Container(color: Colors.red),
          onDismissed: (DismissDirection direction) {
            if (direction == DismissDirection.endToStart) {
              print('swiped end->start');
              deleteProduct(index);
            } else if (direction == DismissDirection.startToEnd)
              print('swiped start->end');
            else
              print('swiped something else');
          },
          child: Column(
            children: <Widget>[
              ListTile(
                leading:
                    CircleAvatar(backgroundImage: AssetImage(product.image)),
                title: Text(product.title),
                subtitle: Text('\$' + product.price.toString()),
                trailing: _buildEditButton(context, product, index),
              ),
              Divider()
            ],
          ),
        );
      },
      itemCount: products.length,
    );
  }

  IconButton _buildEditButton(
      BuildContext context, Product product, int index) {
    return IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return ProductEditPage(
                  product: product,
                  updateProduct: updateProduct,
                  productIndex: index,
                );
              },
            ),
          );
        });
  }
}
