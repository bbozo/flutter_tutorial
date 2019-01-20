import 'package:flutter/material.dart';
import 'package:flutter_tutorial/models/products.dart';
import 'package:flutter_tutorial/models/users.dart';
import 'package:flutter_tutorial/widgets/product/address_tag.dart';
import 'package:flutter_tutorial/widgets/product/price_tag.dart';
import 'package:flutter_tutorial/widgets/ui_elements/default_title.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductCard extends StatelessWidget {
  final int productIndex;

  ProductCard(this.productIndex);

  @override
  Widget build(BuildContext context) {
    UsersModel usersModel = UsersModel.of(context, rebuildOnChange: true);

    return ScopedModelDescendant<ProductsModel>(
      builder: (BuildContext context, Widget child, ProductsModel model) {
        Product product = model.products[productIndex];

        return Card(
          child: Column(
            children: <Widget>[
              FadeInImage(
                image: NetworkImage(product.image),
                height: 300.0,
                fit: BoxFit.cover,
                placeholder: AssetImage('assets/food.jpeg'),
              ),
              _buildProductTitleAndPriceContainer(product),
              AddressTag(product.userEmail),
              AddressTag(product.id != null ? product.id : 'N/A'),
              _buildButtonBar(product, usersModel.toggleFavoriteStatus, context)
            ],
          ),
        );
      },
    );
  }

  Widget _buildButtonBar(
      Product product, Function toggleFavorite, BuildContext context) {
    
    UsersModel usersModel = UsersModel.of(context, rebuildOnChange: true);

    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.info),
          color: Theme.of(context).accentColor,
          onPressed: () => Navigator.pushNamed<bool>(
              context, '/product/' + productIndex.toString()),
        ),
        IconButton(
          icon: Icon(usersModel.isFavorite(product) ? Icons.favorite : Icons.favorite_border),
          color: Colors.red,
          onPressed: () {
            toggleFavorite(productIndex, setLoading: false);
          },
        ),
      ],
    );
  }

  Container _buildProductTitleAndPriceContainer(Product product) {
    return Container(
      padding: EdgeInsets.only(top: 10.00),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          DefaultTitle(product.title),
          SizedBox(width: 8.0),
          PriceTag(product.price),
        ],
      ),
    );
  }
}
