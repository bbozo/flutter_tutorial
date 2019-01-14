import 'package:flutter/material.dart';
import 'package:flutter_tutorial/models/product.dart';
import 'package:flutter_tutorial/pages/product_edit.dart';
import 'package:flutter_tutorial/scoped-models/products.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ProductsModel>(
      builder: (BuildContext context, Widget child, ProductsModel model) {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            final Product product = model.products[index];

            return Dismissible(
              key: Key(product.title),
              background: Container(color: Colors.red),
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.endToStart) {
                  print('swiped end->start');
                  model.deleteProduct(index);
                } else if (direction == DismissDirection.startToEnd)
                  print('swiped start->end');
                else
                  print('swiped something else');
              },
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                        backgroundImage: AssetImage(product.image)),
                    title: Text(product.title),
                    subtitle: Text('\$' + product.price.toString()),
                    trailing: _buildEditButton(context, product, model, index),
                  ),
                  Divider()
                ],
              ),
            );
          },
          itemCount: model.products.length,
        );
      },
    );
  }

  Widget _buildEditButton(BuildContext context, Product product, ProductsModel model, int index) {
    return IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return ProductEditPage(productIndex: index);
              },
            ),
          );
        });
  }
}
