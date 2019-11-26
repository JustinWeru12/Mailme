import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:mailman/style/theme.dart' as Theme;
import 'package:mailman/models/letter.dart';
import 'package:mailman/models/crud.dart';

class LetterPage extends StatefulWidget {
  @override
  _LetterPageState createState() => _LetterPageState();
}

class _LetterPageState extends State<LetterPage> {
  String trackingNo;
  String status;
  String sBox;
  String dBox;
  String description;
  CrudMethods crudObj = new CrudMethods();
  String _myActivityResult;
  final _formKey = new GlobalKey<FormState>();
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _saveForm() {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        _myActivityResult = status;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Letter>>.value(
      child: new Align(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: new Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              padding: EdgeInsets.only(left: 20.0, right: 10.0),
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
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 25.0,
                    ),
                    Text(
                      "Add a New Letter",
                      style: TextStyle(
                          fontSize: 30.0, fontFamily: 'WorkSansSemiBold'),
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    TextFormField(
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
                            FontAwesomeIcons.truck,
                            color: Colors.blue,
                          ),
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(),
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please add the Tracking Number';
                          }
                        },
                        onChanged: (value) {
                          this.trackingNo = value;
                        }),
                    SizedBox(
                      height: 25.0,
                    ),
                    TextFormField(
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
                            FontAwesomeIcons.solidCommentAlt,
                            color: Colors.blue,
                          ),
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(),
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please add a description';
                          }
                        },
                        onChanged: (value) {
                          this.description = value;
                        }),
                    SizedBox(
                      height: 25.0,
                    ),
                    TextFormField(
                        style: TextStyle(
                            fontFamily: "WorkSansSemiBold",
                            fontSize: 16.0,
                            color: Colors.black),
                        autofocus: false,
                        decoration: new InputDecoration(
                          labelText: 'Source Box.',
                          hintStyle: TextStyle(
                              fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                          icon: new Icon(
                            FontAwesomeIcons.box,
                            color: Colors.blue,
                          ),
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(),
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please add a Source address';
                          }
                        },
                        onChanged: (value) {
                          this.sBox = value;
                        }),
                    SizedBox(
                      height: 25.0,
                    ),
                    TextFormField(
                        style: TextStyle(
                            fontFamily: "WorkSansSemiBold",
                            fontSize: 16.0,
                            color: Colors.black),
                        autofocus: false,
                        decoration: new InputDecoration(
                          labelText: 'Destination Box.',
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
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please add a destination address';
                          }
                        },
                        onChanged: (value) {
                          this.dBox = value;
                        }),
                    SizedBox(
                      height: 25.0,
                    ),
                    Container(
                        padding:
                            EdgeInsets.only(left: 45.0, right: 10.0, top: 0.0),
                        child: DropDownFormField(
                          titleText: 'Select Status',
                          hintText: 'Please choose one',
                          value: status,
                          onSaved: (value) {
                            setState(() {
                              status = value;
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              status = value;
                            });
                          },
                          dataSource: [
                            {
                              "display": "Posted",
                              "value": "Posted",
                            },
                            {
                              "display": "Dispatched",
                              "value": "Dispatched",
                            },
                            {"display": "Received", "value": "Received"}
                          ],
                          textField: 'display',
                          valueField: 'value',
                        )),
                    SizedBox(
                      height: 25.0,
                    ),
                    RaisedButton(
                      elevation: 5.0,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      color: Colors.blue,
                      onPressed: () {
                        Navigator.of(context).pop();
                        crudObj.addLetter({
                          'trackingNo': this.trackingNo,
                          'description': this.description,
                          'destination Box': this.dBox,
                          'source Box': this.sBox,
                          'status': this.status
                        }).then((result) {
                          dialogTrigger(context);
                        }).catchError((e) {
                          print(e);
                        });
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
      ),
    );
  }

  Future<bool> dialogTrigger(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Letter Added',
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic)),
            content: Text('Successfully'),
            actions: <Widget>[
              FlatButton(
                child: Text('Done'),
                textColor: Theme.Colors.loginGradientStart,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
