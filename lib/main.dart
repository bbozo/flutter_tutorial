import 'package:flutter/material.dart';
import 'package:flutter_tutorial/models/model_registry.dart';
import 'package:flutter_tutorial/models/products.dart';
import 'package:flutter_tutorial/models/users.dart';
import 'package:scoped_model/scoped_model.dart';
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
  final ModelRegistry _modelRegistry = ModelRegistry();

  @override
  Widget build(BuildContext context) {
    Widget rv;
    UsersModel usersModel = UsersModel(_modelRegistry);
    usersModel.autoAuthenticate();
    
    rv = MaterialApp(
      // debugShowMaterialGrid: true, // shows a grid in which material positions objects
      // home: AuthPage(),
      theme: _buildThemeData(),
      routes: {
        '/': (BuildContext context) => UsersModel.of(context, rebuildOnChange: true).currentUser == null ? AuthPage() : ProductsPage(),
        '/product': (BuildContext context) => ProductsPage(),
        '/admin': (BuildContext context) => ProductAdminPage(),
      },
      onGenerateRoute: (RouteSettings settings) {
        final List<String> pathElements = settings.name.split('/');

        if (pathElements[0] != '') return null;

        if (pathElements[1] == 'product') {
          final int index = int.parse(pathElements[2]);

          return MaterialPageRoute<bool>(
            builder: (BuildContext context) => ProductPage(index),
          );
        }

        return null;
      },
      onUnknownRoute: (RouteSettings settings) {
        print("UNKNOWN ROUTE! " + settings.name);
        return MaterialPageRoute(
          builder: (BuildContext context) => ProductsPage(),
        );
      },
    );

    _modelRegistry.register('users', usersModel);
    rv = ScopedModel<UsersModel>(model: _modelRegistry['users'], child: rv);

    _modelRegistry.register('products', ProductsModel(_modelRegistry));
    rv = ScopedModel<ProductsModel>(model: _modelRegistry['products'], child: rv);

    return rv;
  }

  ThemeData _buildThemeData() {
    return ThemeData(
      primarySwatch: Colors.deepOrange,
      accentColor: Colors.deepPurple,
      buttonColor: Colors.deepPurple,
      brightness: Brightness.light,
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
      ),
    );
  }
}
