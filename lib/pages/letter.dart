import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:mailman/pages/home_page.dart';
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
  final trackingNo = TextEditingController();
  String status;
  TextEditingController sBox = TextEditingController();
  TextEditingController dBox = TextEditingController();
  String dPostalCode;
  DateTime sDate;

  TextEditingController description = TextEditingController();
  CrudMethods crudObj = new CrudMethods();
  // String _myActivityResult;
  final _formKey = new GlobalKey<FormState>();
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // _saveForm() {
  //   var form = _formKey.currentState;
  //   if (form.validate()) {
  //     form.save();
  //     setState(() {
  //       _myActivityResult = status;
  //     });
  //   }
  // }
  void dispose() {
    trackingNo.dispose();
    super.dispose();
  }

  void onButtonPressed() {
    trackingNo.text = DateTime.now().toString();
    print(trackingNo.text);
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Letter>>.value(
      child: new Align(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // new RaisedButton(
              //   elevation: 5.0,
              //   shape: new RoundedRectangleBorder(
              //       borderRadius: new BorderRadius.circular(10.0)),
              //   onPressed: () {
              //     showDialog(
              //       context: context,
              //       barrierDismissible: false,
              //       builder: (BuildContext context) {
              //         return AlertDialog(
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(32.0),
              //           ),
              //           title: SelectableText(
              //             DateTime.now().millisecondsSinceEpoch.toString(),
              //             style: TextStyle(
              //                 fontSize: 20,
              //                 fontFamily: 'Roboto',
              //                 fontWeight: FontWeight.bold,
              //                 fontStyle: FontStyle.italic),
              //             textAlign: TextAlign.justify,
              //           ),
              //           content: Text(
              //             '\n\nGenerated Successfully',
              //             textAlign: prefix0.TextAlign.center,
              //           ),
              //           actions: <Widget>[
              //             FlatButton(
              //               child: Text('Done'),
              //               textColor: Theme.Colors.loginGradientStart,
              //               onPressed: () {
              //                 Navigator.of(context).pop();
              //               },
              //             )
              //           ],
              //         );
              //       },
              //     );
              //   },
              //   child: const Text(
              //     'GENERATE\nTRACKING-No',
              //     style: TextStyle(
              //         fontSize: 20,
              //         fontFamily: 'Spectral',
              //         fontWeight: FontWeight.bold,
              //         fontStyle: FontStyle.normal),
              //     textAlign: TextAlign.center,
              //   ),
              // ),
              // SizedBox(
              //   height: (30.0),
              // ),
              new Card(
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
                        Text("Add a New Letter",
                          style: TextStyle(
                              fontSize: 30.0, fontFamily: 'WorkSansSemiBold'),
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.truck,
                              color: Colors.blue,
                            ),
                          SizedBox( width: 40.0,),
                            Center(
                              child: Text(
                                "The Tracking number will be generated \nautomatically when the details are entered correctly ",
                                style: TextStyle(
                                    fontFamily: "WorkSansSemiBold",
                                    fontSize: 16.0,
                                    color: Colors.black),
                                    textAlign: TextAlign.center,
                              ),
                            ),
                          ],
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
                            labelText: 'Description.',
                            hintText: 'Please add a Description',
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiLight",
                                fontSize: 17.0,
                                fontStyle: prefix0.FontStyle.italic),
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
                            if (value.isEmpty||value.length < 6) {
                              return 'Please add a description';
                            }
                            return null;
                          },
                          controller: description,
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
                            labelText: 'Source Box.',
                            hintText: '123-10100',
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiLight",
                                fontSize: 17.0,
                                fontStyle: prefix0.FontStyle.italic),
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
                            if (value.isEmpty||!value.contains('-')||RegExp(r"^[a-zA-Z]+$").hasMatch(value)) {
                              return 'Please add a valid source address';
                            }
                            return null;
                          },
                          controller: sBox,
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
                            labelText: 'Destination Box.',
                            hintText: '123-10100',
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiLight",
                                fontSize: 17.0,
                                fontStyle: prefix0.FontStyle.italic),
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
                            if (value.isEmpty||!value.contains('-')||RegExp(r'^[a-zA-Z_\=@,\.;]+$').hasMatch(value)) {
                              return 'Please add a valid destination address';
                            }
                            return null;
                          },
                          controller: dBox,
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                        Container(
                            padding: EdgeInsets.only(
                                left: 45.0, right: 10.0, top: 0.0),
                            child: DropDownFormField(
                              titleText: 'Select Destination Postal Office',
                              hintText: 'Please choose one',
                              validator: (value) {
                                if (value == null) {
                                  return "Select the Postal Code";
                                }
                                return null;
                              },
                              value: dPostalCode,
                              onSaved: (value) {
                                setState(() {
                                  dPostalCode = value;
                                });
                              },
                              onChanged: (value) {
                                setState(() {
                                  dPostalCode = value;
                                });
                              },
                              dataSource: [
                                {
                                  "display": "10100",
                                  "value": "10100",
                                },
                                {
                                  "display": "10101",
                                  "value": "10101",
                                },
                                {
                                  "display": "10102",
                                  "value": "10102",
                                },
                                {"display": "10103", "value": "10103"}
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
                            // Navigator.of(context).pop();
                            if (_formKey.currentState.validate()) {
                              crudObj.addLetter({
                                'trackingNo': DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                'description': description.text.toString(),
                                'destination Box': dBox.text.toString(),
                                'source Box': sBox.text.toString(),
                                'status': 'Posted',
                                'destination Postal Code': this.dPostalCode,
                                'sDate': DateTime.now().toString()
                              }).then((result) {
                                dialogTrigger(context);
                                trackingNo.text = '';
                                description.text = '';
                                dBox.text = '';
                                sBox.text = '';
                                // dPostalCode.text = '';
                              }).catchError((e) {
                                print(e);
                              });
                            }
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
              )
            ],
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
            backgroundColor: Theme.Colors.loginGradientStart,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
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
                textColor: Colors.black,
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/');

                  return new HomePage();
                },
              )
            ],
          );
        });
  }
}
