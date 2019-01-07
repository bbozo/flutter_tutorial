import 'package:flutter/material.dart';
import './product_list.dart';
import './product_create.dart';

class ProductAdminPage extends StatelessWidget {
  final Function addProduct;
  final Function deleteProduct;

  ProductAdminPage(this.addProduct, this.deleteProduct);

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
              ProductCreatePage(addProduct),
              ProductListPage()
            ],
          ),
        ));
  }
}
