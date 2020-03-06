import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:mailman/models/letter.dart';
import 'package:mailman/models/letterdetails.dart';
import 'package:mailman/pages/mail.dart';
import 'package:mailman/pages/sent.dart';
import 'package:mailman/services/authentication.dart';
import 'package:mailman/pages/help.dart';
import 'package:mailman/pages/profile.dart';
import 'package:mailman/pages/letter.dart';
import 'package:mailman/style/theme.dart' as Theme;
import 'package:provider/provider.dart';
import 'package:mailman/models/crud.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final logoutCallback;
  final String userId;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String trackingNo;
  String description;
  String sBox;
  String dBox;
  String status;
  DateTime sDate;
  var letters;
  bool myAdmin;
  CrudMethods crudObj = new CrudMethods();

  @override
  void initState() {
    _tabController = new TabController(length: 4, vsync: this);
    crudObj.getData().then((results) {
      setState(() {
        letters = results;
      });
    });
    crudObj.getDataFromUserFromDocument().then((value) {
      Map<String, dynamic> dataMap = value.data;
      setState(() {
        myAdmin = dataMap['admin'];
      });
    });
    super.initState();

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
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: new AppBar(
            backgroundColor: Colors.deepOrange,
            title: Center(
              child: new Text('\t\t\t\t\t\t\t\t\t\tMailman'),
            ),
            textTheme: TextTheme(
              title: TextStyle(
                fontFamily: "WorkSans-Bold",
                color: Colors.blue,
                fontSize: 40.0,
              ),
            ),
            actions: <Widget>[
              Row(
                children: <Widget>[
                  // IconButton(
                  //   icon: Icon(Icons.refresh),
                  //   onPressed: () {
                  //     crudObj.getData().then((results) {
                  //       setState(() {
                  //         letters = results;
                  //       });
                  //     });
                  //   },
                  // ),
                  new SizedBox(
                    width: 5.0,
                  ),
                  new RaisedButton(
                    elevation: 5.0,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0)),
                    color: Colors.blue,
                    child: new Text('Logout',
                        style:
                            new TextStyle(fontSize: 20.0, color: Colors.black)),
                    onPressed: () async {
                      await widget.auth.signOut();
                      widget.logoutCallback();
                    },
                  ),
                ],
              ),
            ],
            bottom: TabBar(
              isScrollable: true,
              unselectedLabelColor: Colors.white,
              labelColor: Colors.amber,
              labelStyle:
                  TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              controller: _tabController,
              tabs: <Widget>[
                new Tab(
                    child: new Row(
                  children: <Widget>[
                    new Icon(Icons.home),
                    new SizedBox(
                      width: 5.0,
                    ),
                    myAdmin == true ? new Text('Home') : new Text('Outbox'),
                  ],
                )),
                new Tab(
                    child: new Row(
                  children: <Widget>[
                    new Icon(Icons.inbox),
                    new SizedBox(
                      width: 5.0,
                    ),
                    myAdmin == true ? new Text('Mail') : new Text('Inbox'),
                  ],
                )),
                new Tab(
                    child: new Row(
                  children: <Widget>[
                    new Icon(Icons.person),
                    new SizedBox(
                      width: 5.0,
                    ),
                    new Text('Profile'),
                  ],
                )),
                new Tab(
                    child: new Row(
                  children: <Widget>[
                    new Icon(Icons.info),
                    new SizedBox(
                      width: 5.0,
                    ),
                    new Text('Info'),
                  ],
                )),
              ],
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            bottomOpacity: 1,
          ),
          body: Stack(
            children: <Widget>[
              Center(
                child: new Image.asset(
                  'assets/envelop.png',
                  width: size.width,
                  height: size.height,
                  fit: BoxFit.fill,
                ),
              ),
              Center(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    myAdmin == true ? _letterList() : Sent(),
                    myAdmin == true ? LetterPage() : Mail(),
                    UserProfil(
                      onSignOut: () {},
                    ),
                    HelpPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
                                'Dispatched') {
                              updateDialog(context,
                                  snapshot.data.documents[i].documentID);
                            }
                            else  if (snapshot.data.documents[i].data['status'] ==
                                'Posted') {
                              updatDialog(context,
                                  snapshot.data.documents[i].documentID);
                            }
                            else updateTrigger(context, snapshot.data.documents[i].documentID);
                          },
                        ),
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
              'The record can only be \nConfirmed or Modified by\nthe Admin if it has not\n been Received or Confirmed.',
              style: TextStyle(
                  fontSize: 20.0,
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
              'Update Status',
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
                    'status': "Received",
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
    Future<bool> updatDialog(BuildContext context, selectedDoc) async {
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
              'Update Status',
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
                    'status': "Dispatched",
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
