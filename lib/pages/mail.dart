import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:mailman/models/letter.dart';
import 'package:mailman/models/letterdetails.dart';
import 'package:mailman/services/authentication.dart';
import 'package:mailman/style/theme.dart' as Theme;
import 'package:provider/provider.dart';
import 'package:mailman/models/crud.dart';

class Mail extends StatefulWidget {
  Mail({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);
  final BaseAuth auth;
  final logoutCallback;
  final String userId;
  @override
  _MailState createState() => _MailState();
}

class _MailState extends State<Mail> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String trackingNo;
  String description;
  String sBox;
  String dBox;
  String status;
  DateTime sDate;
  var letters;
  var myAddress;
  var myPcode;
  var myPhone;
  CrudMethods crudObj = new CrudMethods();
  @override
  void initState() {
    crudObj.getRData().then((results) {
      setState(() {
        letters = results;
      });
    });
    super.initState();
    crudObj.getDataFromUserFromDocument().then((value) {
      Map<String, dynamic> dataMap = value.data;
      setState(() {
        myAddress = dataMap['address'];
        myPcode = dataMap['postalCode'];
        myPhone = dataMap['phone'];
      });
    });
    @override
    signOut() async {
      try {
        await widget.auth.signOut();
        widget.logoutCallback();
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new StreamProvider<List<LetterDetails>>.value(
        value: Letter().letters,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft:  const  Radius.circular(20.0),
                    topRight: const  Radius.circular(20.0),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Theme.Colors.loginGradientStart,
                      Theme.Colors.loginGradientEnd
                    ],
                  ),
                ),
                child: Text(
                  "Welcome, This is the Inbox Window ",
                  style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.black,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.normal),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Center(
                child: Stack(
              children: <Widget>[
                myAddress == "" || myPcode == "" || myPhone == ""
                    ? _textBox()
                    : Container(),
                _letterList(),
              ],
            ))
          ]),
        ));
  }

  Widget divider() {
    return Divider(
      color: Colors.blue,
      height: 15,
      indent: 20,
      endIndent: 20,
    );
  }

  Widget _textBox() {
    return Center(
        child: Card(
      color: Colors.transparent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
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
        child: Container(
          height: 150.0,
          width: 200.0,
          child: Center(
            child: Column(
              children: <Widget>[
                new SizedBox(
                  height: 5.0,
                ),
                Center(
                  child: Text(
                    "Please Complete \nYour Profile \nTo get informed \nas soon as you have mail",
                    style: TextStyle(
                        fontFamily: "WorkSansSemiBold",
                        fontSize: 20.0,
                        color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
                divider(),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Widget _letterList() {
    if (letters != null) {
      return StreamBuilder(
          stream: letters,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context, i) {
                  return Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Container(
                        padding:
                            EdgeInsets.only(left: 20.0, right: 10.0, top: 0.0),
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
                        child: new ListTile(
                            leading: CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.brown[300],
                              backgroundImage: AssetImage('assets/glass.png'),
                            ),
                            title: Text(
                              '\n Tracking No.:${snapshot.data.documents[i].data['trackingNo']}',
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '\nDescription: ${snapshot.data.documents[i].data['description']} \nTo: ${snapshot.data.documents[i].data['destination Box']}\nFrom: ${snapshot.data.documents[i].data['source Box']} \nStatus: ${snapshot.data.documents[i].data['status']}\nOn: ${snapshot.data.documents[i].data['sDate']}\n',
                              style: TextStyle(
                                  fontFamily: 'Spectral', fontSize: 16.0),
                            ),
                            onTap: () {
                              if (snapshot.data.documents[i].data['status'] ==
                                  'Received') {
                                updateDialog(context,
                                    snapshot.data.documents[i].documentID);
                              } else if (snapshot
                                      .data.documents[i].data['status'] ==
                                  'Confirmed') {
                              } else {
                                awaitTrigger(context,
                                    snapshot.data.documents[i].documentID);
                              }
                            },
                            onLongPress: () {
                              if (snapshot.data.documents[i].data['status'] ==
                                  'Confirmed') {
                                dialogTrigger(context,
                                    snapshot.data.documents[i].documentID);
                              } else {
                                updateTrigger(context,
                                    snapshot.data.documents[i].documentID);
                              }
                            }),
                      ));
                },
              );
            } else {
              return Center(
                  child: Text(
                "Welcome. Your list is Loading....",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30.0),
              ));
            }
          });
    } else {
      return Center(
          child: Text(
        "Welcome. Your list is Loading....",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30.0),
      ));
    }
  }

  Future<bool> dialogTrigger(BuildContext context, documentID) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.Colors.loginGradientStart,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
            title: Text(
              'Are you sure you want\n to delete this tile',
              style: TextStyle(
                  fontSize: 25.0,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal),
              textAlign: TextAlign.center,
            ),
            content: Text(
              '',
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Text(
                  'Delete',
                  style: TextStyle(
                      fontSize: 15.0, fontWeight: prefix0.FontWeight.bold),
                ),
                textColor: Colors.red,
                onPressed: () {
                  crudObj.deleteData(documentID);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Future<bool> updateTrigger(BuildContext context, documentID) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.Colors.loginGradientStart,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
            title: Text(
              'The record can only be \ndeleted after Confirmation',
              style: TextStyle(
                  fontSize: 25.0,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal),
              textAlign: TextAlign.center,
            ),
            content: Text(
              '',
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Text(
                  'Done',
                  style: TextStyle(
                      fontSize: 15.0, fontWeight: prefix0.FontWeight.bold),
                ),
                textColor: Colors.black,
                onPressed: () {
                  // crudObj.deleteData(documentID);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Future<bool> awaitTrigger(BuildContext context, documentID) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.Colors.loginGradientStart,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
            title: Text(
              'Your Mail is in Transit.\n Please Await Updates',
              style: TextStyle(
                  fontSize: 25.0,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal),
              textAlign: TextAlign.center,
            ),
            content: Text(
              '',
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Text(
                  'Done',
                  style: TextStyle(
                      fontSize: 15.0, fontWeight: prefix0.FontWeight.bold),
                ),
                textColor: Colors.black,
                onPressed: () {
                  // crudObj.deleteData(documentID);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Future<bool> updateDialog(BuildContext context, selectedDoc) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.Colors.loginGradientStart,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
            title: Text(
              'Update Data',
              style: TextStyle(fontSize: 25.0),
              textAlign: TextAlign.center,
            ),
            // content: Container(
            //   height: 100.0,
            //   width: 150.0,
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: <Widget>[
            //       SizedBox(height: 5.0),
            //       Container(
            //           padding:
            //               EdgeInsets.only(left: 15.0, right: 10.0, top: 0.0),
            //           child: DropDownFormField(
            //             titleText: 'Select Status',
            //             hintText: 'Please choose one',
            //             validator: (value) {
            //               if (value == null) {
            //                 return "Select the letter Status";
            //               }
            //               return null;
            //             },
            //             value: status,
            //             onSaved: (value) {
            //               setState(() {
            //                 status = value;
            //               });
            //             },
            //             onChanged: (value) {
            //               setState(() {
            //                 status = value;
            //               });
            //             },
            //             dataSource: [
            //               {
            //                 "display": "Dispatched",
            //                 "value": "Dispatched",
            //               },
            //               {"display": "Received", "value": "Received"}
            //             ],
            //             textField: 'display',
            //             valueField: 'value',
            //           )),
            //     ],
            //   ),
            // ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Confirm',
                  style: TextStyle(fontFamily: 'Spectral', fontSize: 25.0),
                ),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                  crudObj.updateData(selectedDoc, {
                    'status': "Confirmed",
                    'sDate': DateTime.now().toString()
                  }).then((result) {
                    formKey.currentState.reset();
                    // dialogTrigger(context);
                  }).catchError((e) {
                    print(e);
                  });
                },
              )
            ],
          );
        });
  }
}
