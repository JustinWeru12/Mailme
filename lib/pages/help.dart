import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HelpPage extends StatelessWidget {
  @override
  Widget build (BuildContext ctxt) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Multi Page Application"),
      ),
      body: new Card(
        child: Form(
          child: Column(
            children: <Widget>[
              TextFormField(
                style: TextStyle(
                                      fontFamily: "WorkSansSemiBold",
                                      fontSize: 16.0,
                                      color: Colors.black),
                                  autofocus: false,
                                  decoration: new InputDecoration(
                                      labelText: 'This app was developed and refined by\n \b Waweru P. Ndirangu \n As a Project for the Partial of completion Bsc. Cs ',
                                      hintStyle: TextStyle(
                                          fontFamily: "WorkSansSemiBold",
                                          fontSize: 17.0),
                                      icon: new Icon(
                                        FontAwesomeIcons.envelope,
                                        color: Colors.grey,
                                      ),
                                      border: new OutlineInputBorder(
                                        borderRadius: new BorderRadius.circular(25.0),
                                        borderSide: new BorderSide(),
                                      ),
                                      ),
              )
            ],
          ),
        ),
      )
    );
  }
}