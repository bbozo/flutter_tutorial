import 'package:flutter/material.dart';
import './product_list.dart';
import './product_edit.dart';
import 'package:flutter_tutorial/widgets/ui_elements/sidebar.dart' as sidebar;

class ProductAdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: sidebar.SidebarDrawer(
            children: <Widget>[
              sidebar.AllProductsLink(),
              sidebar.LogoutLink(),
            ],
          ),
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
              ProductEditPage(),
              ProductListPage(),
            ],
          ),
        ));
  }
}
