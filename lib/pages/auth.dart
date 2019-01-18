import 'package:flutter/material.dart';
import 'package:flutter_tutorial/models/users.dart';

import 'package:flutter_tutorial/widgets/helpers/application_helpers.dart' as h;

enum AuthMode { Signup, Login }

class AuthPage extends StatefulWidget {
  @override
  AuthPageState createState() {
    return new AuthPageState();
  }
}

class AuthPageState extends State<AuthPage> {
  Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'showPassword': false,
    'acceptTerms': false,
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordTextController = TextEditingController();

  AuthMode _authMode = AuthMode.Login;

  RegExp emailRegexp = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;

    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Container(
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(.3), BlendMode.dstATop),
            image: AssetImage('assets/background.jpg'),
          ),
        ),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Container(
                width: targetWidth,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      _buildEmailTextField(),
                      SizedBox(height: 10.0),
                      _buildPasswordTextField(),
                      h.renderIf(() => _authMode == AuthMode.Signup,
                          () => _buildConfirmPasswordTextField()),
                      _buildShowPasswordCheckboxListTile(),
                      _buildAcceptTermsSwitchListTile(),
                      SizedBox(height: 10.00),
                      _buildLoginSignupSwitch(),
                      SizedBox(height: 10.00),
                      RaisedButton(
                        child: Text("LOG IN"),
                        onPressed: () =>
                            _submitForm(UsersModel.of(context).login),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  SwitchListTile _buildAcceptTermsSwitchListTile() {
    return SwitchListTile(
      title: Text('Accept terms'),
      value: _formData['acceptTerms'],
      onChanged: (bool value) =>
          setState(() => _formData['acceptTerms'] = value),
    );
  }

  CheckboxListTile _buildShowPasswordCheckboxListTile() {
    return CheckboxListTile(
      title: Text('Show password'),
      value: _formData['showPassword'],
      onChanged: (bool value) =>
          setState(() => _formData['showPassword'] = value),
    );
  }

  TextFormField _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Password', filled: true, fillColor: Colors.white),
      controller: _passwordTextController,
      obscureText: !_formData['showPassword'],
      onSaved: (String value) => _formData['password'] = value,
      validator: (String value) {
        if (value != 'x') return 'Password or e-mail are not valid';
      },
    );
  }

  TextFormField _buildConfirmPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Confirm Password', filled: true, fillColor: Colors.white),
      obscureText: !_formData['showPassword'],
      onSaved: (String value) => _formData['password'] = value,
      validator: (String value) {
        if (value != _passwordTextController.text)
          return "Passwords do not match.";
      },
    );
  }

  TextFormField _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'E-mail', filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.emailAddress,
      onSaved: (String value) => _formData['email'] = value,
      validator: (String value) {
        if (value.isEmpty || !emailRegexp.hasMatch(value))
          return 'Password or e-mail are not valid';
      },
    );
  }

  void _submitForm(Function login) {
    if (!_formKey.currentState.validate() || !_formData['acceptTerms']) return;

    _formKey.currentState.save();
    login(_formData['email'], _formData['password']);
    print('AUTH FORM: ' + _formData.toString());

    Navigator.pushReplacementNamed(context, '/product');
  }

  Widget _buildLoginSignupSwitch() {
    String text;
    AuthMode targetAuthMode;

    if (_authMode == AuthMode.Login) {
      text = "Switch to signup";
      targetAuthMode = AuthMode.Signup;
    } else if (_authMode == AuthMode.Signup) {
      text = "Switch to login";
      targetAuthMode = AuthMode.Login;
    } else
      throw new Exception("WTF");

    return FlatButton(
      child: Text(text),
      onPressed: () => setState(() => _authMode = targetAuthMode),
    );
  }
}
