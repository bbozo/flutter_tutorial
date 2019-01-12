import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget {
  final Function addProduct;

  ProductCreatePage(this.addProduct);

  @override
  _ProductCreatePageState createState() {
    return new _ProductCreatePageState();
  }
}

class _ProductCreatePageState extends State<ProductCreatePage> {
  String _title = '';
  double _price = 0.0;
  String _description = '';
  String _address = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: ListView(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(labelText: 'Product Title'),
            onChanged: (String value) => setState(() => _title = value),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Product Description'),
            maxLines: 4,
            onChanged: (String value) => setState(() => _description = value),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Product Address'),
            maxLines: 4,
            onChanged: (String value) => setState(() => _address = value),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Product Price'),
            keyboardType: TextInputType.number,
            onChanged: (String value) => setState(() => _price = double.parse(value))),
          SizedBox(height: 10.0),
          RaisedButton(
            child: Text('Save'),
            color: Theme.of(context).accentColor,
            textColor: Colors.white,
            onPressed: () {
              final Map<String, dynamic> product = {
                'title': _title,
                'description': _description,
                'address': _address,
                'price': _price,
                'image': 'assets/food.jpeg'
              };
              widget.addProduct(product);
              Navigator.pushNamed(context, '/product');
            },
          )
        ],
      ),
    );
  }
}
