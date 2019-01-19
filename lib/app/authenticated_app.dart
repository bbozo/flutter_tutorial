import 'package:flutter/material.dart';
import 'package:flutter_tutorial/models/model_registry.dart';
import 'package:flutter_tutorial/models/users.dart';
import 'package:flutter_tutorial/models/products.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_tutorial/pages/product.dart';
import 'package:flutter_tutorial/pages/product_admin.dart';
import 'package:flutter_tutorial/pages/products.dart';

class AuthenticatedApp extends StatefulWidget {
  final ModelRegistry modelRegistry;
  final ThemeData theme;
  AuthenticatedApp(this.modelRegistry, {this.theme});

  @override
  AuthenticatedAppState createState() {
    return new AuthenticatedAppState();
  }
}

class AuthenticatedAppState extends State<AuthenticatedApp> {
  ModelRegistry get modelRegistry => widget.modelRegistry;

  @override
  void initState() {
    modelRegistry.register('products', ProductsModel(modelRegistry));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("AuthenticatedApp build()");

    Widget rv;

    rv = MaterialApp(
      // debugShowMaterialGrid: true, // shows a grid in which material positions objects
      theme: widget.theme,
      routes: {
        '/': (BuildContext context) => ProductsPage(),
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

    rv = ScopedModel<UsersModel>(model: modelRegistry['users'], child: rv);
    rv =
        ScopedModel<ProductsModel>(model: modelRegistry['products'], child: rv);

    return rv;
  }

}
