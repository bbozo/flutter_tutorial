import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tutorial/models/model_registry.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tutorial/widgets/helpers/application_helpers.dart' as h;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';

class UsersModel extends RegisteredModel {
  Timer _authTimer;

  PublishSubject<User> _currentUserSubject = PublishSubject();
  PublishSubject<User> get currentUserSubject => _currentUserSubject;

  UsersModel(ModelRegistry modelRegistry) : super(modelRegistry);

  static UsersModel of(BuildContext context, {rebuildOnChange: false}) =>
      ScopedModel.of<UsersModel>(context, rebuildOnChange: rebuildOnChange);

  User _currentUser;
  bool _isLoading = false;

  User get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('current-user/token');
    final String email = prefs.getString('current-user/email');
    final String id = prefs.getString('current-user/id');
    final String expirationTimeString =
        prefs.get('current-user/expiration_time');
    if (token != null) {
      final DateTime now = DateTime.now();
      final expiresAt = DateTime.parse(expirationTimeString);
      if (expiresAt.isBefore(now)) {
        logout();
        return;
      }
      _login(User(email: email, id: id, token: token, expiresAt: expiresAt));
    }
  }

  Future<Null> logout() {
    return SharedPreferences.getInstance().then((SharedPreferences prefs) {
      print("LOGOUT");
      prefs.remove('current-user/token');
      prefs.remove('current-user/email');
      prefs.remove('current-user/id');
      prefs.remove('current-user/expiration_time');
      _currentUser = null;
      _currentUserSubject.add(null);
      _authTimer?.cancel();
    });
  }

  void _setAuthTimeout(int time) {
    print("Logging out in $time seconds");
    _authTimer = Timer(Duration(seconds: time), () {
      logout();
    });
  }

  Future<Map<String, dynamic>> loginOnline(String email, String password) {
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
        .then(_loginUserFromOnline)
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
        .then(_loginUserFromOnline)
        .catchError(_errorHandler);
  }

  Map<String, dynamic> _processResult(http.Response httpResponse) {
    final Map<String, dynamic> rv = json.decode(httpResponse.body);
    print(rv);
    if (rv.containsKey('error'))
      throw new FirebaseError(rv['error']['message']);

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

  Map<String, dynamic> _loginUserFromOnline(Map<String, dynamic> rv) {
    int expiresIn = int.parse(rv['expiresIn']);
    final DateTime expirationTime =
        DateTime.now().add(Duration(seconds: expiresIn));
    rv['user'] = User(
      id: rv['localId'],
      email: rv['email'],
      token: rv['idToken'],
      expiresAt: expirationTime,
    );
    _login(rv['user']);

    return rv;
  }

  Future<User> _login(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    _currentUser = user;
    prefs.setString('current-user/token', _currentUser.token);
    prefs.setString('current-user/id', _currentUser.id);
    prefs.setString('current-user/email', _currentUser.email);
    prefs.setString('current-user/expiration_time',
        _currentUser.expiresAt.toIso8601String());

    int expiresIn = _currentUser.expiresAt.difference(DateTime.now()).inSeconds;
    _setAuthTimeout(expiresIn);
    _currentUserSubject.add(_currentUser);

    return _currentUser;
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
  final DateTime expiresAt;

  User({
    @required this.id,
    @required this.email,
    @required this.token,
    @required this.expiresAt,
  });
}
