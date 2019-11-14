import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

class LetterPage extends StatefulWidget {
  @override
  _LetterPageState createState() => _LetterPageState();
}

class _LetterPageState extends State<LetterPage> {
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
                SizedBox(height: 25.0,),
                Text(
                  "Add a New Letter",
                  style:
                      TextStyle(fontSize: 30.0, fontFamily: 'WorkSansSemiBold'),
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
                    labelText: 'Tracking No.',
                    hintStyle: TextStyle(
                        fontFamily: "WorkSansSemiBold", fontSize: 17.0),
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
                    labelText: 'Description.',
                    hintStyle: TextStyle(
                        fontFamily: "WorkSansSemiBold", fontSize: 17.0),
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
                Container(
                    padding: EdgeInsets.only(left: 40.0, right: 20, top: 20),
                    child: DropDownFormField(
                      titleText: 'Select Status',
                      hintText: 'Please choose one',
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
                          "display": "Posted",
                          "value": "Posted",
                        },
                        {
                          "display": "Sent",
                          "value": "Sent",
                        },
                        {
                          "display": "Received",
                          "value": "Received",
                        },
                        {
                          "display": "Confirmed",
                          "value": "Confirmed",
                        },
                      ],
                      textField: 'display',
                      valueField: 'value',
                    )),
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
