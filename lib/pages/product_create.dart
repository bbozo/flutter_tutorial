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
  final bool doValidation = true;

  final Map<String, dynamic> _formData = {
    'title': '',
    'price': 0.0,
    'details': '',
    'address': '',
  };

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

  Widget _buildTitleTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Product Title'),
      onSaved: (String value) => _formData['title'] = value,
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
      onSaved: (String value) => _formData['price'] = double.parse(value),
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
      onSaved: (String value) => _formData['address'] = value,
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
      onSaved: (String value) => _formData['details'] = value,
      validator: (String value) {
        if (value.isEmpty || value.length < 5)
          return 'Details are required and should be 5+ characters long';
      },
    );
  }

  void _submitForm() {
    if (doValidation && !_formKey.currentState.validate()) return;
    
    // TODO: remove me
    _formData['image'] = 'assets/food.jpeg';

    _formKey.currentState.save();
    widget.addProduct(_formData);
    Navigator.pushNamed(context, '/product');
  }
}
