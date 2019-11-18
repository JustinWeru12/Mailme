import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:mailman/style/theme.dart' as Theme;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String trackingNo;

  String sentDate;

  String description;
  String _myActivity;
  String _myActivityResult;
  final formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _myActivity = '';
    _myActivityResult = '';
  }

  _saveForm() {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        _myActivityResult = _myActivity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Align(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: new Card(
          elevation: 5.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(
            padding: EdgeInsets.only(left: 20.0, right: 10.0, top: 0.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Theme.Colors.loginGradientStart,
                  Theme.Colors.loginGradientEnd
                ],
              ),
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 25.0,
                  ),
                  Text(
                    "Create a Profile",
                    style: TextStyle(
                        fontSize: 30.0, fontFamily: 'WorkSansSemiBold'),
                  ),
                  SizedBox(height: 25.0),
                  TextField(
                    style: TextStyle(
                        fontFamily: "WorkSansSemiBold",
                        fontSize: 16.0,
                        color: Colors.black),
                    autofocus: false,
                    decoration: new InputDecoration(
                      labelText: 'Full Names.',
                      hintStyle: TextStyle(
                          fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                      icon: new Icon(
                        FontAwesomeIcons.solidUser,
                        color: Colors.blue,
                      ),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  TextField(
                    style: TextStyle(
                        fontFamily: "WorkSansSemiBold",
                        fontSize: 16.0,
                        color: Colors.black),
                    autofocus: false,
                    decoration: new InputDecoration(
                      labelText: 'Email.',
                      hintStyle: TextStyle(
                          fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                      icon: new Icon(
                        FontAwesomeIcons.at,
                        color: Colors.blue,
                      ),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  TextField(
                    style: TextStyle(
                        fontFamily: "WorkSansSemiBold",
                        fontSize: 16.0,
                        color: Colors.black),
                    autofocus: false,
                    decoration: new InputDecoration(
                      labelText: 'Phone No.',
                      hintStyle: TextStyle(
                          fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                      icon: new Icon(
                        FontAwesomeIcons.solidAddressBook,
                        color: Colors.blue,
                      ),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  TextField(
                    style: TextStyle(
                        fontFamily: "WorkSansSemiBold",
                        fontSize: 16.0,
                        color: Colors.black),
                    autofocus: false,
                    decoration: new InputDecoration(
                      labelText: 'Age.',
                      hintStyle: TextStyle(
                          fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                      icon: new Icon(
                        FontAwesomeIcons.githubAlt,
                        color: Colors.blue,
                      ),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  TextField(
                    style: TextStyle(
                        fontFamily: "WorkSansSemiBold",
                        fontSize: 16.0,
                        color: Colors.black),
                    autofocus: false,
                    decoration: new InputDecoration(
                      labelText: 'Address.',
                      hintStyle: TextStyle(
                          fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                      icon: new Icon(
                        FontAwesomeIcons.solidEnvelopeOpen,
                        color: Colors.blue,
                      ),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  TextField(
                    style: TextStyle(
                        fontFamily: "WorkSansSemiBold",
                        fontSize: 16.0,
                        color: Colors.black),
                    autofocus: false,
                    decoration: new InputDecoration(
                      labelText: 'Postal Code.',
                      hintStyle: TextStyle(
                          fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                      icon: new Icon(
                        FontAwesomeIcons.boxOpen,
                        color: Colors.blue,
                      ),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  RaisedButton(
                    elevation: 5.0,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: Colors.blue,
                    onPressed: () {
                      print('Submit Button clicked');
                    },
                    child: const Text('SUBMIT',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic)),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
