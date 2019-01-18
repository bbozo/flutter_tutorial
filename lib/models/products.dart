import 'package:flutter/material.dart';
import 'package:flutter_tutorial/models/model_registry.dart';
import 'package:flutter_tutorial/models/users.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductsModel extends RegisteredModel {
  static const String PRODUCTS_URL =
      'https://flutter-tutorial-c6c13.firebaseio.com/products';

  ProductsModel(ModelRegistry modelRegistry) : super(modelRegistry) {
    fetchProducts();
    notifyListeners();
  }

  static ProductsModel of(BuildContext context) =>
      ScopedModel.of<ProductsModel>(context);

  List<Product> _products = [];
  bool _showFavorites = false;
  bool _isLoading = false;

  List<Product> get products => List.of(_products);
  bool get showFavorites => _showFavorites;
  User get currentUser => (modelRegistry['users'] as UsersModel).currentUser;
  bool get isLoading => _isLoading;

  List<Product> get displayedProducts {
    if (_showFavorites)
      return products.where((Product product) => product.isFavorite).toList();
    else
      return products;
  }

  void toggleShowFavorites() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }

  Future<bool> fetchProducts({bool setLoading = true}) {
    _setIsLoading(setLoading: setLoading);

    return http
        .get('$PRODUCTS_URL.json')
        .then(_validateHttpResponse)
        .then((http.Response httpResponse) {
      print(httpResponse.body);

      Map<String, dynamic> response = json.decode(httpResponse.body);
      _products = [];

      if (response != null) {
        response.forEach((String id, dynamic mapobj) {
          Map<String, dynamic> map = mapobj as Map<String, dynamic>;
          map['id'] = id;
          Product product = Product.fromMap(map);
          _products.add(product);
        });
      }

      _isLoading = false;
      notifyListeners();

      return true;
    }).catchError(_errorHandler);
  }

  http.Response _validateHttpResponse(http.Response httpResponse) {
    print("validating http response $httpResponse");
    if (httpResponse.statusCode < 200 || httpResponse.statusCode > 201)
      throw new Exception("invalid response from server");
    print("  all OK");
    return httpResponse;
  }

  Future<bool> addProduct(Product product, {bool setLoading = true}) {
    _setIsLoading(setLoading: setLoading);

    if (currentUser != null) {
      product.userId = currentUser.id;
      product.userEmail = currentUser.email;
    }

    return http
        .post(
          '$PRODUCTS_URL.json',
          body: json.encode(product.toMap()),
        )
        .then(_validateHttpResponse)
        .then(
      (http.Response httpResponse) {
        final Map<String, dynamic> resp = json.decode(httpResponse.body);
        product.id = resp['name'];
        _products.add(product);

        _isLoading = false;
        notifyListeners();

        return true;
      },
    ).catchError(_errorHandler);
  }

  Future<bool> deleteProduct(int index, {bool setLoading = true}) {
    _setIsLoading(setLoading: setLoading);

    Product product = _products[index];

    return http
        .delete(
          '$PRODUCTS_URL/${product.id}.json',
        )
        .then(_validateHttpResponse)
        .then((http.Response resp) {
      _products.removeAt(index);
      _isLoading = false;
      notifyListeners();

      return true;
    }).catchError(_errorHandler);
  }

  Future<bool> updateProduct(int index, Product product,
      {bool setLoading = true}) {
    _setIsLoading(setLoading: setLoading);

    if (currentUser != null) {
      product.userId = currentUser.id;
      product.userEmail = currentUser.email;
    }

    product = _products[index].update(product);

    Function updateState = (Product product) {
      _isLoading = false;
      _products[index] = product;
      notifyListeners();
    };

    if (!setLoading) updateState(product);

    return http
        .put(
          '$PRODUCTS_URL/${product.id}.json',
          body: json.encode(product.toMap()),
        )
        .then(_validateHttpResponse)
        .then(
      (http.Response httpResponse) {
        final Map<String, dynamic> resp = json.decode(httpResponse.body);
        Product product = Product.fromMap(resp);
        if (setLoading) updateState(product);
        return true;
      },
    ).catchError(_errorHandler);
  }

  Future<void> toggleFavoriteStatus(int index, {bool setLoading = true}) {
    return updateProduct(
        index, Product(isFavorite: !products[index].isFavorite),
        setLoading: setLoading);
  }

  void _setIsLoading({bool setLoading = true}) {
    if (setLoading) {
      _isLoading = true;
      notifyListeners();
    }
  }

  bool _errorHandler(error) {
    _isLoading = false;
    notifyListeners();
    print("ERROR!! $error");
    return false;
  }
}

class Product {
  String id;
  String title;
  String details;
  double price;
  String address;
  String image;
  bool isFavorite;
  String userId;
  String userEmail;

  Product(
      {this.id,
      this.title,
      this.details,
      this.price,
      this.address,
      this.image,
      this.userId,
      this.userEmail,
      this.isFavorite = false});

  static Product fromMap(Map<String, dynamic> map) {
    // print('fromMap received: ${map.toString()}');
    return Product(
      id: map['id'],
      title: map['title'],
      details: map['details'],
      price: map['price'].toDouble(),
      address: map['address'],
      image: map['image'],
      isFavorite: map['is_favorite'] ?? false,
      userId: map['user_id'],
      userEmail: map['user_email'],
    );
  }

  Product update(Product alt) {
    return Product(
      id: alt.id ?? id,
      title: alt.title ?? title,
      details: alt.details ?? details,
      price: alt.price ?? price,
      address: alt.address ?? address,
      image: alt.image ?? image,
      isFavorite: alt.isFavorite ?? isFavorite,
      userId: alt.userId ?? userId,
      userEmail: alt.userEmail ?? userEmail,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'details': details,
      'price': price,
      'address': address,
      'image': image,
      'is_favorite': isFavorite,
      'user_id': userId,
      'user_email': userEmail
    };
  }
}
