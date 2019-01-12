import 'package:flutter/material.dart';
import 'package:flutter_tutorial/widgets/product/products.dart';

class ProductsPage extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  ProductsPage(this.products);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          child: Column(
        children: <Widget>[
          AppBar(title: Text('Choose'), automaticallyImplyLeading: false),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/admin');
            },
          ),
        ],
      )),
      appBar: AppBar(
        title: Text('EasyList'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {},
          ),
        ],
      ),
      
      // NOTE: Products returns a ListView, a ListView can't be used below another widget
      // (the container with the button/ProductController). We wrap the Products ListView into
      // a container of it's own. Container is fixed in size, Expandable is the way to go.    
      body: Column(
        children: <Widget>[
          Expanded(child: Products(products)),
        ],
      ),
    );
  }
}
