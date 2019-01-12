import 'package:flutter/material.dart';

typedef void _FormValueSetter(String value);

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
  String _details = '';
  String _address = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    return Container(
      margin: EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Container(
          width: targetWidth, // doesnt work with ListView !!!!
          child: Form(
            key: _formKey,
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
        ),
      ),
    );
  }

  FormFieldSetter<String> _setValue(_FormValueSetter setter) {
    return ((String value) {
      setState(() => setter(value));
      return;
    });
  }

  Widget _buildTitleTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Product Title'),
      onSaved: _setValue((String value) => _title = value),
      validator: (String value) {
        if (value.isEmpty || value.length < 5)
          return 'Title is required and should be 5+ characters long';
      },
    );
  }

  Widget _buildPriceTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Product Price'),
      keyboardType: TextInputType.number,
      onSaved: _setValue((String value) => _price = double.parse(value)),
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value))
          return 'Price is required and should be a number';
      },
    );
  }

  Widget _buildAddressTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Product Address'),
      maxLines: 4,
      onSaved: _setValue((String value) => _address = value),
      validator: (String value) {
        if (value.isEmpty || value.length < 5)
          return 'Address is required and should be 5+ characters long';
      },
    );
  }

  Widget _buildDescriptionTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Product Details'),
      maxLines: 4,
      onSaved: _setValue((String value) => _details = value),
      validator: (String value) {
        if (value.isEmpty || value.length < 5)
          return 'Details are required and should be 5+ characters long';
      },
    );
  }

  void _submitForm() {
    if (!_formKey.currentState.validate()) return;

    _formKey.currentState.save();
    final Map<String, dynamic> product = {
      'title': _title,
      'details': _details,
      'address': _address,
      'price': _price,
      'image': 'assets/food.jpeg'
    };
    widget.addProduct(product);
    Navigator.pushNamed(context, '/product');
  }
}
