import 'package:flutter/material.dart';
import 'package:flutter_tutorial/models/model_registry.dart';
import 'package:scoped_model/scoped_model.dart';

class UsersModel extends RegisteredModel {
  UsersModel(ModelRegistry modelRegistry) : super(modelRegistry);
  
  static UsersModel of(BuildContext context) =>
      ScopedModel.of<UsersModel>(context);

  User _currentUser;

  User get currentUser => _currentUser;

  void login(String email, String password) {
    _currentUser = User(id: 'foo', email: email, password: password);
  }
}

class User {
  final String id;
  final String email;
  final String password;

  User({
    @required this.id,
    @required this.email,
    @required this.password,
  });
}
