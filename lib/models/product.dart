import 'package:flutter/material.dart';

class Product {
  final String title;
  final String details;
  final double price;
  final String address;
  final String image;
  bool isFavorite;

  Product({
    @required this.title,
    @required this.details,
    @required this.price,
    @required this.address,
    @required this.image,
    this.isFavorite = false
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'details': details,
      'price': price,
      'address': address,
      'image': image
    };
  }

}
