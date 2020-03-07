import 'package:flutter/material.dart';
import 'package:mailman/services/authentication.dart';
import 'package:mailman/pages/root_page.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Mailman',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.light
        ),
        home: new RootPage(auth: new Auth()));
  }
}
