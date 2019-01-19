import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tutorial/models/model_registry.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tutorial/widgets/helpers/application_helpers.dart' as h;

import 'package:shared_preferences/shared_preferences.dart';

class UsersModel extends RegisteredModel {
  UsersModel(ModelRegistry modelRegistry) : super(modelRegistry);

  static UsersModel of(BuildContext context, {rebuildOnChange: false}) =>
      ScopedModel.of<UsersModel>(context, rebuildOnChange: rebuildOnChange);

  User _currentUser;
  bool _isLoading = false;

  User get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  void autoAuthenticate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('current-user/token');
    String email = prefs.getString('current-user/email');
    String id = prefs.getString('current-user/id');
    if (token != null) {
      _currentUser = User(email: email, id: id, token: token);
      notifyListeners();
    }
  }

  Future<Null> logout() {
    return SharedPreferences.getInstance().then((SharedPreferences prefs) {
      prefs.remove('current-user/token');
      prefs.remove('current-user/email');
      prefs.remove('current-user/id');
      _currentUser = null;
      notifyListeners();
    });
  }

  Future<Map<String, dynamic>> login(String email, String password) {
    _setIsLoading(true);
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    return http
        .post(
            "https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=${h.firebaseConfig['apiKey']}",
            body: json.encode(authData))
        .then(_processResult)
        .then(_processSuccess)
        .then(_setCurrentUser)
        .catchError(_errorHandler);
  }

  Future<Map<String, dynamic>> signup(String email, String password) {
    _setIsLoading(true);
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    return http
        .post(
            "https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=${h.firebaseConfig['apiKey']}",
            body: json.encode(authData))
        .then(_processResult)
        .then(_processSuccess)
        .then(_setCurrentUser)
        .catchError(_errorHandler);
  }

  Map<String, dynamic> _processResult(http.Response httpResponse) {
    final Map<String, dynamic> rv = json.decode(httpResponse.body);
    print(rv);
    if (rv.containsKey('error'))
      throw new FirebaseError(rv['error']['message']);
    return rv;
  }

  Map<String, dynamic> _processSuccess(Map<String, dynamic> response) {
    final Map<String, dynamic> rv = Map.of(response);
    rv.addAll({'success': true, 'message': 'Authentication succeeded!'});
    _setIsLoading(false);
    return rv;
  }

  Map<String, dynamic> _errorHandler(error) {
    _setIsLoading(false);
    if (error is FirebaseError) {
      switch (error.msg) {
        case 'EMAIL_EXISTS':
          return {'success': false, 'message': 'E-mail already exists'};
        case 'EMAIL_NOT_FOUND':
        case 'INVALID_PASSWORD':
          return {'success': false, 'message': 'E-mail or password is invalid'};
        case 'USER_DISABLED':
          return {'success': false, 'message': 'User is disabled'};
        default:
          return {'success': false, 'message': error.msg};
      }
    } else
      return {'success': false, 'message': error.toString()};
  }

  Future<Map<String, dynamic>> _setCurrentUser(Map<String, dynamic> rv) async {
    final String token = rv['idToken'];
    _currentUser = User(id: rv['localId'], email: rv['email'], token: token);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('current-user/token', _currentUser.token);
    prefs.setString('current-user/id', _currentUser.id);
    prefs.setString('current-user/email', _currentUser.email);

    return rv;
  }

  void _setIsLoading(bool value, {bool setLoadingIndicator = true}) {
    if (setLoadingIndicator) {
      _isLoading = value;
      notifyListeners();
    }
  }
}

class FirebaseError implements Exception {
  final String msg;
  FirebaseError(this.msg) : super();
}

class User {
  final String id;
  final String email;
  final String token;

  User({@required this.id, @required this.email, @required this.token});
}
