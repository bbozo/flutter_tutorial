import 'package:flutter/material.dart';
import 'package:flutter_tutorial/models/products.dart';
import 'package:flutter_tutorial/widgets/product/product_card.dart';
import 'package:scoped_model/scoped_model.dart';

class Products extends StatelessWidget {
  
  Widget _buildProductList(BuildContext context, List<Product> products) {       
    Widget rv;
    ProductsModel model = ProductsModel.of(context);

    if (model.isLoading)
      rv = Center(child: rv = CircularProgressIndicator());

    else if (products.length == 0)
      rv = Center(child: Text("No products found, please add some"));

    else
      rv = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            ProductCard(index),
        itemCount: products.length,
      );

    return rv;
  }

  @override
  Widget build(BuildContext context) {
    print("[Products Widget] build()");
    return ScopedModelDescendant<ProductsModel>(
      builder: (BuildContext context, Widget child, ProductsModel model) {
        return _buildProductList(context, model.displayedProducts);
      },
    );
  }
}
