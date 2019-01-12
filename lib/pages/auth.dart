import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  AuthPageState createState() {
    return new AuthPageState();
  }
}

class AuthPageState extends State<AuthPage> {
  String _emailValue = '';
  String _passwordValue = '';
  bool _showPasswordValue = false;
  bool _acceptTerms = false;

  @override
  Widget build(BuildContext context) {
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
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _buildEmailTextField(),
                SizedBox(height: 10.0),
                _buildPasswordTextField(),
                buildShowPasswordCheckboxListTile(),
                buildAcceptTermsSwitchListTile(),
                SizedBox(height: 10.00),
                RaisedButton(
                  child: Text("LOG IN"),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: _submitForm,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SwitchListTile buildAcceptTermsSwitchListTile() {
    return SwitchListTile(
        title: Text('Accept terms'),
        value: _acceptTerms,
        onChanged: (bool value) => setState(() => _acceptTerms = value));
  }

  CheckboxListTile buildShowPasswordCheckboxListTile() {
    return CheckboxListTile(
      title: Text('Show password'),
      value: _showPasswordValue,
      onChanged: (bool value) => setState(() => _showPasswordValue = value),
    );
  }

  TextField _buildPasswordTextField() {
    return TextField(
        decoration: InputDecoration(
            labelText: 'Password', filled: true, fillColor: Colors.white),
        obscureText: !_showPasswordValue,
        onChanged: (String value) => setState(() => _passwordValue = value));
  }

  TextField _buildEmailTextField() {
    return TextField(
      decoration: InputDecoration(
          labelText: 'E-mail', filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.emailAddress,
      onChanged: (String value) => setState(() => _emailValue = value),
    );
  }

  void _submitForm() {
    print('email ' + _emailValue + '   password ' + _passwordValue);
    Navigator.pushReplacementNamed(context, '/product');
  }
}
