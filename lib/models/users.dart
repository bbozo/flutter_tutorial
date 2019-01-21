import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tutorial/models/model_registry.dart';
import 'package:flutter_tutorial/models/products.dart';
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

  List<Product> get products =>
      (modelRegistry['products'] as ProductsModel).products;

  User _currentUser;
  bool _isLoading = false;

  User get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String currentUserJson = prefs.getString('current-user');

    if (currentUserJson != null) {
      final Map<String, dynamic> userMap = json.decode(currentUserJson);
      User user = User.fromMap(userMap);

      if (user.expiresAt.isBefore(DateTime.now())) {
        logout();
        return;
      }
      _login(user);
    }
  }

  Future<Null> logout() {
    return SharedPreferences.getInstance().then((SharedPreferences prefs) {
      print("LOGOUT");
      prefs.remove('current-user');
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
        .then(_addToFirebase)
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
        .then(_addToFirebase)
        .then(_loginUserFromOnline)
        .catchError(_errorHandler);
  }

  Map<String, dynamic> _processResult(http.Response httpResponse) {
    final Map<String, dynamic> rv = json.decode(httpResponse.body);
    print(rv);
    if (rv.containsKey('error'))
      throw new FirebaseError(rv['error']['message']);

    rv.addAll({'success': true, 'message': 'Authentication succeeded!'});

    return rv;
  }

  static const String USERS_URL =
      'https://flutter-tutorial-c6c13.firebaseio.com/users';

  String _usersUrl(String id, String token) =>
      '$USERS_URL/$id.json?auth=$token}';

  Future<Map<String, dynamic>> _addToFirebase(Map<String, dynamic> resp) async {
    final Map<String, dynamic> rv = Map.of(resp);

    final Map<String, dynamic> userMap = {
      'id': resp['localId'],
      'email': resp['email'],
      'token': resp['idToken'],
    };
    final String url = _usersUrl(userMap['id'], userMap['token']);

    http.Response getUserResponse = await http.get(url);
    http.Response changeUserResponse;

    Map<String, dynamic> userMapForPost = Map.of(userMap);
    userMapForPost.remove('token');
    if (getUserResponse.statusCode == 404)
      changeUserResponse =
          await http.post(url, body: json.encode(userMapForPost));
    else if (getUserResponse.statusCode >= 200 &&
        getUserResponse.statusCode <= 201)
      changeUserResponse =
          await http.put(url, body: json.encode(userMapForPost));
    else {
      print(getUserResponse.body);
      throw new FirebaseError("invalid getUserResponse from firebase");
    }

    final Map<String, dynamic> response = json.decode(changeUserResponse.body);
    print("RESPONSE " + response.toString());

    User user = User.fromMap(userMap);
    rv['user'] = user;

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
    } else {
      throw error;
      // return {'success': false, 'message': error.toString()};
    }
  }

  Future<void> toggleFavoriteStatus(int index, {bool setLoading = true}) {
    Product product = products[index];
    List<String> ps = currentUser.likedProducts;
    
    if (ps.indexOf(product.id) == -1)
      ps.add(product.id);
    else
      ps.remove(product.id);
    
    notifyListeners();

    final String url = _usersUrl(currentUser.id, currentUser.token);
    print(currentUser.toMap());

    return http
        .put(url,
            body: json.encode(currentUser.toMap(withoutSensitiveData: true)))
        .then((http.Response h) => print(h.body));
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
    
    _setIsLoading(false);
    notifyListeners();

    return rv;
  }

  Future<User> _login(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    _currentUser = user;
    prefs.setString('current-user', json.encode(_currentUser.toMap()));

    int expiresIn = _currentUser.expiresAt.difference(DateTime.now()).inSeconds;
    _setAuthTimeout(expiresIn);
    _currentUserSubject.add(_currentUser);

    return _currentUser;
  }

  bool isFavorite(Product product) =>
      currentUser.likedProducts.contains(product.id);

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
  List<String> likedProducts;

  static User fromMap(Map<String, dynamic> m) {
    DateTime expiresAt =
        m.containsKey('expires_at') ? DateTime.parse(m['expires_at']) : null;
    List<String> likedProducts = m['liked_products'] != null
        ? List<String>.of(m['liked_products'])
        : List<String>();

    return User(
      id: m['id'],
      email: m['email'],
      token: m['token'],
      expiresAt: expiresAt,
      likedProducts: likedProducts,
    );
  }

  Map<String, dynamic> toMap({bool withoutSensitiveData: false}) {
    Map<String, dynamic> rv = {
      'id': id,
      'email': email,
      'token': token,
      'expires_at': expiresAt?.toIso8601String(),
      'liked_products': likedProducts
    };

    if (withoutSensitiveData) {
      rv.remove('token');
      rv.remove('expires_at');
    }

    return rv;
  }

  User({
    @required this.id,
    @required this.email,
    @required this.token,
    @required this.expiresAt,
    this.likedProducts,
  }) {
    if (likedProducts == null) likedProducts = List<String>();
  }
}
