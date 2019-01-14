import 'package:flutter_tutorial/models/product.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductsModel extends Model {
  List<Product> _products = [];
  bool _showFavorites = false;

  List<Product> get products {
    return List.from(_products);
  }

  bool get showFavorites => _showFavorites;

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

  ProductsModel() {
    seed();
  }

  void seed() {
    _products.add(Product(
      title: 'Choccolate',
      image: 'assets/food.jpeg',
      price: 25.5,
      details: 'Choccolate description in\nmultiple lines.',
      address: 'Union Square, San Francisco',
    ));
    _products.add(Product(
      title: 'Cookies',
      image: 'assets/food.jpeg',
      price: 15.5,
      details: 'Cookies description in\nmultiple lines.\nAnd more lines.',
      address: 'Union Square, San Francisco',
    ));
    notifyListeners();
  }

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
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
    _products[index].isFavorite = !_products[index].isFavorite;
    notifyListeners();
  }
}
