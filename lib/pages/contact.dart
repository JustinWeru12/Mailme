import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LetterPage extends StatelessWidget {
  String trackingNo;
  String sentDate;
  String description;
  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
        body: new Card(
      child: Form(
        child: Column(
          children: <Widget>[
            TextField(
              style: TextStyle(
                  fontFamily: "WorkSansSemiBold",
                  fontSize: 16.0,
                  color: Colors.black),
              autofocus: false,
              decoration: new InputDecoration(
                labelText: 'Tracking No.',
                hintStyle:
                    TextStyle(fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                icon: new Icon(
                  FontAwesomeIcons.envelope,
                  color: Colors.grey,
                ),
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: new BorderSide(),
                ),
              ),
            ),
            DropdownButtonFormField<String>(
              items: <String>['Posted', 'Sent', 'Received', 'Confirmed'].map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (_) {},
            )
          ],
        ),
      ),
    ));
  }
}
