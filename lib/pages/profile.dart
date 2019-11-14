import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

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
          color: Colors.blue[50],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox( height: 25.0,),
                Text(
                  "Create a Profile",
                  style:
                      TextStyle(fontSize: 30.0, fontFamily: 'WorkSansSemiBold'),
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
                      FontAwesomeIcons.user,
                      color: Colors.grey,
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
                      color: Colors.grey,
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
                      color: Colors.grey,
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
                Container(
                    padding: EdgeInsets.only(left: 40.0, right: 20, top: 20),
                    child: DropDownFormField(
                      titleText: 'Select Gender',
                      hintText: 'Please a Gender',
                      value: _myActivity,
                      onSaved: (value) {
                        setState(() {
                          _myActivity = value;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          _myActivity = value;
                        });
                      },
                      dataSource: [
                        {
                          "display": "Female",
                          "value": "Female",
                        },
                        {
                          "display": "Male",
                          "value": "Male",
                        },
                        {
                          "display": "Other",
                          "value": "Other",
                        },
                      ],
                      textField: 'display',
                      valueField: 'value',
                    )),
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
                      FontAwesomeIcons.envelopeOpen,
                      color: Colors.grey,
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
                      FontAwesomeIcons.addressBook,
                      color: Colors.grey,
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
                  child: const Text('SUBMIT', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
