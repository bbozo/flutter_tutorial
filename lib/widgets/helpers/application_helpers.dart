import 'package:flutter/material.dart';

Widget renderIf(Function condition, Function builder) {
  if (condition())
    return builder();
  else
    return Container();
}

Future<dynamic> errorDialog(BuildContext context, {title: 'Something went wrong', content: 'Please try again'}) {
  return showDialog(
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
      context: context);
}

Map<String, dynamic> firebaseConfig = {
  'apiKey': "AIzaSyCbX5cIrZBm4optQIjFB-NnLtZPnmz8-sE",
  'authDomain': "flutter-tutorial-c6c13.firebaseapp.com",
  'databaseURL': "https://flutter-tutorial-c6c13.firebaseio.com",
  'projectId': "flutter-tutorial-c6c13",
  'storageBucket': "flutter-tutorial-c6c13.appspot.com",
  'messagingSenderId': "875516715108"
};
