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
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    return Container(
      margin: EdgeInsets.all(10.0),
      child: Container(
        width: targetWidth, // doesnt work with ListView !!!!
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
          children: <Widget>[
            _buildTitleTextField(),
            _buildDescriptionTextField(),
            _buildAddressTextField(),
            _buildPriceTextField(),
            SizedBox(height: 10.0),
            // GestureDetector(
            //   onTap: _submitForm,
            //   child: Container(
            //     color: Colors.green,
            //     padding: EdgeInsets.all(5),
            //     child: Text('My Button'),
            //   ),
            // )
            RaisedButton(
              child: Text('Save'),
              onPressed: _submitForm,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTitleTextField() {
    return TextField(
      decoration: InputDecoration(labelText: 'Product Title'),
      onChanged: (String value) => setState(() => _title = value),
    );
  }

  TextField _buildPriceTextField() {
    return TextField(
        decoration: InputDecoration(labelText: 'Product Price'),
        keyboardType: TextInputType.number,
        onChanged: (String value) =>
            setState(() => _price = double.parse(value)));
  }

  TextField _buildAddressTextField() {
    return TextField(
      decoration: InputDecoration(labelText: 'Product Address'),
      maxLines: 4,
      onChanged: (String value) => setState(() => _address = value),
    );
  }

  TextField _buildDescriptionTextField() {
    return TextField(
      decoration: InputDecoration(labelText: 'Product Description'),
      maxLines: 4,
      onChanged: (String value) => setState(() => _description = value),
    );
  }

  _submitForm() {
    final Map<String, dynamic> product = {
      'title': _title,
      'description': _description,
      'address': _address,
      'price': _price,
      'image': 'assets/food.jpeg'
    };
    widget.addProduct(product);
    Navigator.pushNamed(context, '/product');
  }
}
