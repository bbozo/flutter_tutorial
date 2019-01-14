import 'package:flutter/material.dart';
import 'package:flutter_tutorial/models/product.dart';

import '../widgets/helpers/ensure-visible.dart';

class ProductEditPage extends StatefulWidget {
  final Product product;
  final int productIndex;
  final Function addProduct;
  final Function updateProduct;

  ProductEditPage(
      {this.addProduct, this.updateProduct, this.productIndex, this.product}) {
    if (isNew())
      assert(this.addProduct != null);
    else {
      assert(this.updateProduct != null);
      assert(this.productIndex != null);
    }
  }

  bool isNew() {
    return product == null;
  }

  @override
  _ProductEditPageState createState() {
    return new _ProductEditPageState();
  }
}

class _ProductEditPageState extends State<ProductEditPage> {
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

  @override
  void initState() {
    if (!isNew()) _formData = widget.product.toMap();
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isNew() => widget.isNew();

  @override
  Widget build(BuildContext context) {
    Widget pageContent = Container(
      margin: EdgeInsets.all(10.0),
      child: _buildPageContent(context),
    );

    if (!isNew()) {
      return Scaffold(
          appBar: AppBar(title: Text('Edit Product')), body: pageContent);
    } else
      return pageContent;
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
              RaisedButton(
                child: Text('Save'),
                onPressed: _submitForm,
              )
            ],
          ),
        ),
      ),
    );
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
        onSaved: (String value) => _formData['price'] = double.parse(value),
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

    final Product product = Product(
      title: _formData['title'],
      details: _formData['details'],
      address: _formData['address'],
      image: 'assets/food.jpeg',
      price: _formData['price'],
    );

    _formKey.currentState.save();

    if (isNew())
      widget.addProduct(product);
    else
      widget.updateProduct(widget.productIndex, product);

    Navigator.pushNamed(context, '/product');
  }
}
