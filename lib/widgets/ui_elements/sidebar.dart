import 'package:flutter/material.dart';
import 'package:flutter_tutorial/models/users.dart';

class SidebarDrawer extends StatelessWidget {
  final List<Widget> children;

  SidebarDrawer({@required this.children});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
              AppBar(title: Text('Choose'), automaticallyImplyLeading: false),
            ] +
            children,
      ),
    );
  }
}

class AllProductsLink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.shop),
      title: Text('All Products'),
      onTap: () {
        Navigator.pushReplacementNamed(context, '/product');
      },
    );
  }
}

class LogoutLink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(Icons.exit_to_app),
        title: Text('Log out'),
        onTap: () {
          UsersModel.of(context, rebuildOnChange: true)
              .logout()
              .then((_) => Navigator.pushReplacementNamed(context, '/'));
        });
  }
}

class ManageProductsLink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.edit),
      title: Text('Manage Products'),
      onTap: () {
        Navigator.pushReplacementNamed(context, '/admin');
      },
    );
  }
}
