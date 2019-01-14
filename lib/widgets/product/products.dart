import 'package:flutter/material.dart';
import 'package:flutter_tutorial/models/product.dart';
import 'package:flutter_tutorial/scoped-models/products.dart';
import 'package:flutter_tutorial/widgets/product/product_card.dart';
import 'package:scoped_model/scoped_model.dart';

class Products extends StatelessWidget {
  
  Widget _buildProductList(List<Product> products) {
    Widget productCard =
        Center(child: Text("No products found, please add some"));

    if (products.length > 0)
      productCard = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            ProductCard(index, products[index]),
        itemCount: products.length,
      );

    return productCard;
  }

  @override
  Widget build(BuildContext context) {
    print("[Products Widget] build()");
    return ScopedModelDescendant<ProductsModel>(
      builder: (BuildContext context, Widget child, ProductsModel model) {
        return _buildProductList(model.products);
      },
    );
  }
}
