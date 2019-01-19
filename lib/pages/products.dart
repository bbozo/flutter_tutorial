import 'package:flutter/material.dart';
import 'package:flutter_tutorial/models/products.dart';
import 'package:flutter_tutorial/widgets/product/products.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_tutorial/widgets/ui_elements/sidebar.dart' as sidebar;

class ProductsPage extends StatefulWidget {
  @override
  ProductsPageState createState() {
    return new ProductsPageState();
  }
}

class ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    ProductsModel.of(context).fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ProductsModel>(
      builder: (BuildContext context, Widget child, ProductsModel model) {
        return Scaffold(
          drawer: sidebar.SidebarDrawer(
            children: <Widget>[
              sidebar.ManageProductsLink(),
              sidebar.LogoutLink(),
            ],
          ),
          appBar: AppBar(
            title: Text('EasyList'),
            actions: <Widget>[
              IconButton(
                icon: Icon(model.showFavorites
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  model.toggleShowFavorites();
                },
              ),
            ],
          ),

          // NOTE: Products returns a ListView, a ListView can't be used below another widget
          // (the container with the button/ProductController). We wrap the Products ListView into
          // a container of it's own. Container is fixed in size, Expandable is the way to go.
          body: Column(
            children: <Widget>[
              Expanded(child: Products()),
            ],
          ),
        );
      },
    );
  }
}
