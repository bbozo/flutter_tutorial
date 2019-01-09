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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
              onChanged: (String value) => setState(() => _emailValue = value),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: !_showPasswordValue,
              onChanged: (String value) => setState(() => _passwordValue = value),
            ),
            CheckboxListTile(
              title: Text('Show password'),
              value: _showPasswordValue,
              onChanged: (bool value) => setState(() => _showPasswordValue = value),
            ),
            SizedBox(height: 10.00),
            RaisedButton(
              child: Text("LOG IN"),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () {
                print('email ' + _emailValue + '   password ' + _passwordValue);
                Navigator.pushReplacementNamed(context, '/product');
              },
            ),
          ],
        ),
      ),
    );
  }
}
