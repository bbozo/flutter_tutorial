import 'package:flutter/material.dart';
import 'package:flutter_tutorial/models/products.dart';
import 'package:flutter_tutorial/widgets/helpers/application_helpers.dart' as h;

import '../widgets/helpers/ensure-visible.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductEditPage extends StatefulWidget {
  final int productIndex;

  ProductEditPage({this.productIndex});

  @override
  _ProductEditPageState createState() {
    return new _ProductEditPageState();
  }
}

class _ProductEditPageState extends State<ProductEditPage> {
  Product selectedProduct;

  final bool doValidation = true;

  final _titleFocusNode = FocusNode();
  final _detailsFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();

  Map<String, dynamic> _formData = {
    'title': '',
    'price': '',
    'details': '',
    'address': '',
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ProductsModel productsModel;

  bool _isNew() {
    return widget.productIndex == null;
  }

  int get productIndex => widget.productIndex;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ProductsModel>(
        builder: (BuildContext context, Widget child, ProductsModel model) {
      productsModel = model;

      if (!_isNew()) _formData = model.products[productIndex].toMap();

      Widget pageContent = Container(
        margin: EdgeInsets.all(10.0),
        child: _buildPageContent(context),
      );

      if (!_isNew()) {
        return Scaffold(
            appBar: AppBar(title: Text('Edit Product')), body: pageContent);
      } else
        return pageContent;
    });
  }

  Widget _buildPageContent(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    return GestureDetector(
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
              _buildSubmitButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    ProductsModel model = ProductsModel.of(context);

    Widget rv;

    if (model.isLoading)
      rv = Center(child: rv = CircularProgressIndicator());
    else
      rv = RaisedButton(
        child: Text('Save'),
        onPressed: _submitForm,
      );

    return rv;
  }

  Widget _buildTitleTextField() {
    return EnsureVisibleWhenFocused(
      focusNode: _titleFocusNode,
      child: TextFormField(
        decoration: InputDecoration(labelText: 'Product Title'),
        focusNode: _titleFocusNode,
        initialValue: _formData['title'],
        onSaved: (String value) => _formData['title'] = value,
        validator: (String value) {
          if (value.isEmpty || value.length < 5)
            return 'Title is required and should be 5+ characters long';
        },
      ),
    );
  }

  Widget _buildPriceTextField() {
    return EnsureVisibleWhenFocused(
      focusNode: _priceFocusNode,
      child: TextFormField(
        decoration: InputDecoration(labelText: 'Product Price'),
        initialValue: _formData['price'].toString(),
        focusNode: _priceFocusNode,
        keyboardType: TextInputType.number,
        onSaved: (String value) => _formData['price'] = value,
        validator: (String value) {
          if (value.isEmpty ||
              !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value))
            return 'Price is required and should be a number';
        },
      ),
    );
  }

  Widget _buildAddressTextField() {
    return EnsureVisibleWhenFocused(
      focusNode: _addressFocusNode,
      child: TextFormField(
        decoration: InputDecoration(labelText: 'Product Address'),
        initialValue: _formData['address'],
        focusNode: _addressFocusNode,
        onSaved: (String value) => _formData['address'] = value,
        validator: (String value) {
          if (value.isEmpty || value.length < 5)
            return 'Address is required and should be 5+ characters long';
        },
      ),
    );
  }

  Widget _buildDescriptionTextField() {
    return EnsureVisibleWhenFocused(
      focusNode: _detailsFocusNode,
      child: TextFormField(
        decoration: InputDecoration(labelText: 'Product Details'),
        focusNode: _detailsFocusNode,
        initialValue: _formData['details'],
        maxLines: 4,
        onSaved: (String value) => _formData['details'] = value,
        validator: (String value) {
          if (value.isEmpty || value.length < 5)
            return 'Details are required and should be 5+ characters long';
        },
      ),
    );
  }

  void _submitForm() {
    if (doValidation && !_formKey.currentState.validate()) return;
    _formKey.currentState.save();

    final Product product = Product(
      title: _formData['title'],
      details: _formData['details'],
      address: _formData['address'],
      image:
          'https://cdn.pixabay.com/photo/2015/10/02/12/00/chocolate-968457_960_720.jpg',
      price: double.parse(_formData['price']),
    );

    Function navigateAway = (bool success) {
      if (success)
        Navigator.pushReplacementNamed(context, '/product');
      else
        h.somethingWentWrongDialog(context);
    };

    if (_isNew())
      productsModel.addProduct(product).then(navigateAway);
    else
      productsModel.updateProduct(productIndex, product).then(navigateAway);
  }
}
