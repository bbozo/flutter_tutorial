import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class UsersModel extends Model {
  User _currentUser;

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
