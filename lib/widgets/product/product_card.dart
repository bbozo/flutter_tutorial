import 'package:flutter/material.dart';
import 'package:flutter_tutorial/models/product.dart';
import 'package:flutter_tutorial/widgets/product/address_tag.dart';
import 'package:flutter_tutorial/widgets/product/price_tag.dart';
import 'package:flutter_tutorial/widgets/ui_elements/default_title.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final productIndex;

  ProductCard(this.productIndex, this.product);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(product.image),
          _buildProductTitleAndPriceContainer(),
          AddressTag(product.address),
          _buildButtonBar(context)
        ],
      ),
    );
  }

  ButtonBar _buildButtonBar(BuildContext context) {
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
          icon: Icon(Icons.favorite_border),
          color: Colors.red,
          onPressed: () {},
        ),
      ],
    );
  }

  Container _buildProductTitleAndPriceContainer() {
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
