import 'package:flutter/material.dart';
import 'package:flutter_tutorial/models/model_registry.dart';
import 'package:flutter_tutorial/models/users.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductsModel extends RegisteredModel {
  static const String PRODUCTS_URL =
      'https://flutter-tutorial-c6c13.firebaseio.com/products.json';

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

  void fetchProducts() {
    _isLoading = true;
    notifyListeners();
    http.get(PRODUCTS_URL).then((http.Response httpResponse) {
      print(httpResponse.body);

      Map<String, dynamic> response = json.decode(httpResponse.body);
      _products = [];

      if (response != null) {
        response.forEach((String id, dynamic mapobj) {
          Map<String, dynamic> map = mapobj as Map<String, dynamic>;
          final product = Product(
            id: id,
            address: map['address'] ?? 'N/A',
            details: map['details'] ?? 'N/A',
            image: map['image'] ?? 'N/A',
            price: map['price'].toDouble() ?? null,
            title: map['title'] ?? 'N/A',
            isFavorite: map['is_favorite'] ?? false,
            userEmail: map['user_email'] ?? 'N/A',
            userId: map['user_id'] ?? 'N/A',
          );
          _products.add(product);
        });
      }

      _isLoading = false;
      notifyListeners();
    });
  }

  Future<Null> addProduct(Product product) {
    _isLoading = true;
    notifyListeners();

    if (currentUser != null) {
      product.userId = currentUser.id;
      product.userEmail = currentUser.email;
    }

    return http
        .post(
      PRODUCTS_URL,
      body: json.encode(product.toMap()),
    )
        .then(
      (http.Response httpResponse) {
        final Map<String, dynamic> resp = json.decode(httpResponse.body);
        product.id = resp['name'];
        _products.add(product);
        
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void deleteProduct(int index) {
    _products.removeAt(index);
    notifyListeners();
  }

  void updateProduct(int index, Product product) {
    _products[index] = product;
    notifyListeners();
  }

  void toggleFavoriteStatus(int index) {
    _products[index].isFavorite = !products[index].isFavorite;
    notifyListeners();
  }
}

class Product {
  String id;
  final String title;
  final String details;
  final double price;
  final String address;
  final String image;
  bool isFavorite;
  String userId;
  String userEmail;

  Product(
      {this.id,
      @required this.title,
      @required this.details,
      @required this.price,
      @required this.address,
      @required this.image,
      this.userId,
      this.userEmail,
      this.isFavorite = false});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'details': details,
      'price': price,
      'address': address,
      'image': image,
      // 'user_id': userId,
      // 'user_email': userEmail
    };
  }
}
