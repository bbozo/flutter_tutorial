import 'package:flutter/material.dart';
import 'package:flutter_tutorial/models/model_registry.dart';
import 'package:flutter_tutorial/models/users.dart';
import 'package:flutter_tutorial/pages/auth.dart';
import 'package:scoped_model/scoped_model.dart';

class GuestApp extends StatelessWidget {
  final ModelRegistry modelRegistry;
  final ThemeData theme;

  GuestApp(this.modelRegistry, {this.theme});

  @override
  Widget build(BuildContext context) {
    Widget rv = MaterialApp(
      home: AuthPage(),
      theme: theme,
    );
    
    rv = ScopedModel<UsersModel>(model: modelRegistry['users'], child: rv);

    return rv;
  }
}
