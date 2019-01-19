import 'package:flutter/material.dart';
import 'package:flutter_tutorial/app/authenticated_app.dart';
import 'package:flutter_tutorial/app/guest_app.dart';
import 'package:flutter_tutorial/models/model_registry.dart';
import 'package:flutter_tutorial/models/users.dart';

// import 'package:flutter/rendering.dart';

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
  User currentUser;
  ModelRegistry _modelRegistry = ModelRegistry();

  @override
  void initState() {
    UsersModel usersModel = UsersModel(_modelRegistry);
    _modelRegistry.register('users', usersModel);
    usersModel.autoAuthenticate();
    usersModel.currentUserSubject.listen((user) => setState(() => currentUser = user));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null)
      return GuestApp(_modelRegistry, theme: _buildThemeData());
    else
      return AuthenticatedApp(_modelRegistry, theme: _buildThemeData());
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
