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
        decoration: _buildMainContainerDecoration(),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Container(
                width: targetWidth,
                child: _buildForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Form _buildForm() {
    UsersModel usersModel = UsersModel.of(context, rebuildOnChange: true);
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _buildEmailTextField(),
          SizedBox(height: 10.0),
          _buildPasswordTextField(),
          _signUpOrLogin<Widget>(
              () => _buildConfirmPasswordTextField(), () => Container()),
          _buildShowPasswordCheckboxListTile(),
          _buildAcceptTermsSwitchListTile(),
          SizedBox(height: 10.00),
          _buildLoginSignupSwitch(),
          SizedBox(height: 10.00),
          _buildSubmitButton(usersModel),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(UsersModel usersModel) {
    if (usersModel.isLoading)
      return CircularProgressIndicator();
    else
      return RaisedButton(
        child: Text(_signUpOrLogin<String>(() => "SIGN UP", () => "LOG IN")),
        onPressed: () => _submitForm(usersModel.loginOnline, usersModel.signup),
      );
  }

  BoxDecoration _buildMainContainerDecoration() {
    return BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.cover,
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(.3), BlendMode.dstATop),
        image: AssetImage('assets/background.jpg'),
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
      // initialValue: 'xxxxxx',
      obscureText: !_formData['showPassword'],
      onSaved: (String value) => _formData['password'] = value,
      validator: (String value) {},
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
      initialValue: 'xx@xx.xx',
      onSaved: (String value) => _formData['email'] = value,
      validator: (String value) {
        if (value.isEmpty || !emailRegexp.hasMatch(value))
          return 'Password or e-mail are not valid';
      },
    );
  }

  void _submitForm(Function login, Function signup) async {
    if (!_formKey.currentState.validate() || !_formData['acceptTerms']) return;

    _formKey.currentState.save();
    print('AUTH FORM: ' + _formData.toString());

    final Map<String, dynamic> result =
        await _signUpOrLogin<Future<Map<String, dynamic>>>(
      () => signup(_formData['email'], _formData['password']),
      () => login(_formData['email'], _formData['password']),
    );

    if (result['success'])
      Navigator.pushReplacementNamed(context, '/');
    else
      h.errorDialog(context,
          title: 'An Error Ocurred', content: result['message']);
  }

  T _signUpOrLogin<T>(Function signUp, Function login) {
    if (_authMode == AuthMode.Login)
      return login();
    else if (_authMode == AuthMode.Signup)
      return signUp();
    else
      throw new Exception("WTF");
  }

  Widget _buildLoginSignupSwitch() {
    String text;
    AuthMode targetAuthMode;

    _signUpOrLogin(() {
      text = "Switch to login";
      targetAuthMode = AuthMode.Login;
    }, () {
      text = "Switch to signup";
      targetAuthMode = AuthMode.Signup;
    });

    return FlatButton(
      child: Text(text),
      onPressed: () => setState(() => _authMode = targetAuthMode),
    );
  }
}
