import 'package:flutter/material.dart';
import 'package:flutter_tutorial/pages/product.dart';
import 'package:flutter_tutorial/pages/product_admin.dart';
import 'package:flutter_tutorial/pages/products.dart';
// import 'package:flutter/rendering.dart';

import './pages/auth.dart';

void main() {
  // debugPaintSizeEnabled = true;  // shows how and why elements fit together
  // debugPaintBaselinesEnabled = true; // shows baselines of texts, not sure when useful
  // debugPaintPointersEnabled = true;  // shows point-click-gesture events
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() {
    return new _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  List<Map<String, dynamic>> _products = [];

  void _addProduct(Map<String, dynamic> product) {
    setState(() {
      _products.add(product);
    });
  }

  void _deleteProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowMaterialGrid: true, // shows a grid in which material positions objects
      // home: AuthPage(),
      theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.deepPurple,
          brightness: Brightness.light),
      routes: {
        '/': (BuildContext context) =>
            AuthPage(),
        '/product': (BuildContext context) => ProductsPage(_products),
        '/admin': (BuildContext context) => ProductAdminPage(_addProduct, _deleteProduct),
      },
      onGenerateRoute: (RouteSettings settings) {
        final List<String> pathElements = settings.name.split('/');

        if (pathElements[0] != '') return null;

        if (pathElements[1] == 'product') {
          final int index = int.parse(pathElements[2]);
          Map<String, dynamic> product = _products[index];

          return MaterialPageRoute<bool>(
            builder: (BuildContext context) =>
                ProductPage(product['title'], product['image']),
          );
        }

        return null;
      },
      onUnknownRoute: (RouteSettings settings) {
        print("UNKNOWN ROUTE! " + settings.name);
        return MaterialPageRoute(
              builder: (BuildContext context) =>
                  ProductsPage(_products),
            );
      },
    );
  }
}
