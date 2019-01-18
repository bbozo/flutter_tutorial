import 'package:flutter/material.dart';
import 'package:flutter_tutorial/models/products.dart';
import 'package:flutter_tutorial/pages/product_edit.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductListPage extends StatefulWidget {
  @override
  ProductListPageState createState() {
    return new ProductListPageState();
  }
}

class ProductListPageState extends State<ProductListPage> {
  ProductsModel model;

  @override
  void initState() {
    model = ProductsModel.of(context);
    model.fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ProductsModel>(
      builder: (BuildContext context, Widget child, ProductsModel model) {
        if(model.isLoading)
          return Center(child: CircularProgressIndicator());
        else
          return _buildProductsListView(model);
      },
    );
  }

  ListView _buildProductsListView(ProductsModel model) {
    return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          final Product product = model.products[index];

          return Dismissible(
            key: Key(product.title),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (DismissDirection direction) {
              if (direction == DismissDirection.endToStart) {
                print('swiped end->start');
                model.deleteProduct(index, setLoading: false);
              } else if (direction == DismissDirection.startToEnd)
                print('swiped start->end');
              else
                print('swiped something else');
            },
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                      backgroundImage: NetworkImage(product.image)),
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
