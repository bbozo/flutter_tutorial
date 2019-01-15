import 'package:flutter/material.dart';
import 'package:flutter_tutorial/models/model_registry.dart';
import 'package:flutter_tutorial/models/users.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductsModel extends RegisteredModel {
  ProductsModel(ModelRegistry modelRegistry) : super(modelRegistry) {
    seed();
  }

  static ProductsModel of(BuildContext context) =>
      ScopedModel.of<ProductsModel>(context);

  List<Product> _products = [];
  bool _showFavorites = false;

  List<Product> get products => List.of(_products);
  bool get showFavorites => _showFavorites;
  User get currentUser => (modelRegistry['users'] as UsersModel).currentUser;

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

  void seed() {
    _products.add(Product(
        title: 'Choccolate',
        image: 'assets/food.jpeg',
        price: 25.5,
        details: 'Choccolate description in\nmultiple lines.',
        address: 'Union Square, San Francisco',
        userEmail: 'wii@user.com',
        userId: 'abcdef'));
    _products.add(Product(
        title: 'Cookies',
        image: 'assets/food.jpeg',
        price: 15.5,
        details: 'Cookies description in\nmultiple lines.\nAnd more lines.',
        address: 'Union Square, San Francisco',
        userEmail: 'wii@user.com',
        userId: 'abcdef'));
    notifyListeners();
  }

  void addProduct(Product product) {
    if(currentUser != null) {
      product.userId = currentUser.id;
      product.userEmail = currentUser.email;
    }

    http
        .post(
      'https://flutter-tutorial-c6c13.firebaseio.com/products.json',
      body: json.encode(product.toMap()),
    )
        .then(
      (http.Response httpResponse) {
        final Map<String, dynamic> resp = json.decode(httpResponse.body);
        product.id = resp['name'];
        _products.add(product);
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
