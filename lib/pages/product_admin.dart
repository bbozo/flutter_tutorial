import 'package:flutter/material.dart';
import 'package:flutter_tutorial/models/product.dart';
import './product_list.dart';
import './product_edit.dart';

class ProductAdminPage extends StatelessWidget {
  final List<Product> products;
  final Function addProduct;
  final Function deleteProduct;
  final Function updateProduct;

  ProductAdminPage(this.products, this.addProduct, this.deleteProduct, this.updateProduct);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: Drawer(
              child: Column(
            children: <Widget>[
              AppBar(title: Text('Choose'), automaticallyImplyLeading: false),
              ListTile(
                leading: Icon(Icons.shop),
                title: Text('All Products'),
                onTap: () {
                  Navigator.pushReplacementNamed(
                      context,
                      '/product');
                },
              ),
            ],
          )),
          appBar: AppBar(
            title: Text('Manage Products'),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(text: 'Create Product', icon: Icon(Icons.create)),
                Tab(text: 'My Products', icon: Icon(Icons.list)),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              ProductEditPage(addProduct: addProduct),
              ProductListPage(products, updateProduct, deleteProduct)
            ],
          ),
        ));
  }
}
