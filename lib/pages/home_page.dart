import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:mailman/services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mailman/models/letter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'package:mailman/pages/datepicker.dart';
import 'package:mailman/pages/help.dart';
import 'package:mailman/pages/profile.dart';
import 'package:mailman/pages/contact.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List<Letter> _letterList;
  TabController _tabController;
  String _trackingno;
  final _formKey = GlobalKey();
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _textEditingController = TextEditingController();
  StreamSubscription<Event> _onLetterAddedSubscription;
  StreamSubscription<Event> _onLetterChangedSubscription;

  Query _letterQuery;

  //bool _isEmailVerified = false;

  @override
  void initState() {
    _tabController = new TabController(length: 4, vsync: this);
    super.initState();

    //_checkEmailVerification();

    _letterList = new List();
    _letterQuery = _database
        .reference()
        .child("letter")
        .orderByChild("userId")
        .equalTo(widget.userId);
    _onLetterAddedSubscription = _letterQuery.onChildAdded.listen(onEntryAdded);
    _onLetterChangedSubscription =
        _letterQuery.onChildChanged.listen(onEntryChanged);
  }

//  void _checkEmailVerification() async {
//    _isEmailVerified = await widget.auth.isEmailVerified();
//    if (!_isEmailVerified) {
//      _showVerifyEmailDialog();
//    }
//  }

//  void _resentVerifyEmail(){
//    widget.auth.sendEmailVerification();
//    _showVerifyEmailSentDialog();
//  }

//  void _showVerifyEmailDialog() {
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        // return object of type Dialog
//        return AlertDialog(
//          title: new Text("Verify your account"),
//          content: new Text("Please verify account in the link sent to email"),
//          actions: <Widget>[
//            new FlatButton(
//              child: new Text("Resent link"),
//              onPressed: () {
//                Navigator.of(context).pop();
//                _resentVerifyEmail();
//              },
//            ),
//            new FlatButton(
//              child: new Text("Dismiss"),
//              onPressed: () {
//                Navigator.of(context).pop();
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }

//  void _showVerifyEmailSentDialog() {
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        // return object of type Dialog
//        return AlertDialog(
//          title: new Text("Verify your account"),
//          content: new Text("Link to verify account has been sent to your email"),
//          actions: <Widget>[
//            new FlatButton(
//              child: new Text("Dismiss"),
//              onPressed: () {
//                Navigator.of(context).pop();
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }

  @override
  void dispose() {
    _onLetterAddedSubscription.cancel();
    _onLetterChangedSubscription.cancel();
    super.dispose();
  }

  onEntryChanged(Event event) {
    var oldEntry = _letterList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _letterList[_letterList.indexOf(oldEntry)] =
          Letter.fromSnapshot(event.snapshot);
    });
  }

  onEntryAdded(Event event) {
    setState(() {
      _letterList.add(Letter.fromSnapshot(event.snapshot));
    });
  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  addNewLetter(String letterItem) {
    if (letterItem.length > 0) {
      Letter letter = new Letter(letterItem.toString(), widget.userId, false);
      _database.reference().child("letter").push().set(letter.toJson());
    }
  }

  updateLetter(Letter letter) {
    //Toggle completed
    letter.completed = !letter.completed;
    if (letter != null) {
      _database
          .reference()
          .child("letter")
          .child(letter.key)
          .set(letter.toJson());
    }
  }

  deleteLetter(String letterId, int index) {
    _database.reference().child("letter").child(letterId).remove().then((_) {
      print("Delete $letterId successful");
      setState(() {
        _letterList.removeAt(index);
      });
    });
  }

  showAddLetterDialog(BuildContext context) async {
    _textEditingController.clear();
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Row(
              children: <Widget>[
                new Expanded(
                  child: Builder(
                      builder: (context) => Container(
                          // padding: const EdgeInsets.all(30.0),
                          height: 200,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                new Padding(
                                    padding: EdgeInsets.only(top: 20.0)),
                                TextFormField(
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontFamily: "WorkSansSemiBold",
                                      fontSize: 16.0,
                                      color: Colors.black),
                                  autofocus: false,
                                  decoration: new InputDecoration(
                                    hintText: 'Tracking Number',
                                    hintStyle: TextStyle(
                                        fontFamily: "WorkSansSemiBold",
                                        fontSize: 17.0),
                                    icon: new Icon(
                                      FontAwesomeIcons.envelope,
                                      color: Colors.grey,
                                    ),
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(25.0),
                                      borderSide: new BorderSide(),
                                    ),
                                  ),
                                  validator: (value) => value.isEmpty
                                      ? 'Enter the Tracking Number assigned'
                                      : null,
                                  onSaved: (value) =>
                                      _trackingno = value.trim(),
                                ),
                                TextFormField(
                                  maxLines: 1,
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(
                                      fontFamily: "WorkSansSemiBold",
                                      fontSize: 16.0,
                                      color: Colors.black),
                                  autofocus: false,
                                  decoration: new InputDecoration(
                                      hintText: 'Description',
                                      hintStyle: TextStyle(
                                          fontFamily: "WorkSansSemiBold",
                                          fontSize: 17.0),
                                      icon: new Icon(
                                        FontAwesomeIcons.envelope,
                                        color: Colors.grey,
                                      ),
                                      border: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(25.0),
                                        borderSide: new BorderSide(),
                                      )),
                                  validator: (value) => value.isEmpty
                                      ? 'Enter a brief description assigned'
                                      : null,
                                  onSaved: (value) =>
                                      _trackingno = value.trim(),
                                ),
                                FlatButton(
                                    onPressed: () {
                                      DatePicker.showDateTimePicker(context,
                                          showTitleActions: true,
                                          onChanged: (date) {
                                        print('change $date in time zone ' +
                                            date.timeZoneOffset.inHours
                                                .toString());
                                      }, onConfirm: (date) {
                                        print('confirm $date');
                                      },
                                          currentTime: DateTime(
                                              2008, 12, 31, 23, 12, 34));
                                    },
                                    child: Text(
                                      'Select Date',
                                      style: TextStyle(color: Colors.blue),
                                    )),
                              ],
                            ),
                          ))),
                ),
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new FlatButton(
                  child: const Text('Save'),
                  onPressed: () {
                    addNewLetter(_textEditingController.text.toString());
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  Widget showLetterList() {
    if (_letterList.length > 0) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: _letterList.length,
          itemBuilder: (BuildContext context, int index) {
            String letterId = _letterList[index].key;
            String subject = _letterList[index].subject;
            bool completed = _letterList[index].completed;
            String userId = _letterList[index].userId;
            return Dismissible(
              key: Key(letterId),
              background: Container(color: Colors.red),
              onDismissed: (direction) async {
                deleteLetter(letterId, index);
              },
              child: ListTile(
                title: Text(
                  subject,
                  style: TextStyle(fontSize: 20.0),
                ),
                trailing: IconButton(
                    icon: (completed)
                        ? Icon(
                            Icons.done_outline,
                            color: Colors.green,
                            size: 20.0,
                          )
                        : Icon(Icons.done, color: Colors.grey, size: 20.0),
                    onPressed: () {
                      updateLetter(_letterList[index]);
                    }),
              ),
            );
          });
    } else {
      return Center(
          child: Text(
        "Welcome. Your list is empty",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30.0),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: DefaultTabController(
            length: 4,
            child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.deepOrangeAccent,
                  title: Center(
                    child: new Text('Mailman'),
                  ),
                  textTheme: TextTheme(
                    title: TextStyle(
                      fontFamily: "WorkSans-Bold",
                      color: Colors.blue,
                      fontSize: 40.0,
                    ),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                        child: new Text('Logout',
                            style: new TextStyle(
                                fontSize: 25.0,
                                color: Colors.blue,
                                backgroundColor: Colors.amber)),
                        onPressed: signOut)
                  ],
                  bottom: TabBar(
                    isScrollable: true,
                    unselectedLabelColor: Colors.white,
                    labelColor: Colors.amber,
                    labelStyle: TextStyle(fontSize:20.0,fontWeight: FontWeight.bold),
                    controller: _tabController,
                    tabs: <Widget>[
                      new Tab(
                          child: new Row(
                        children: <Widget>[
                          new Icon(Icons.home),
                          new SizedBox(
                            width: 5.0,
                          ),
                          new Text('Home'),
                        ],
                      )),
                      new Tab(
                          child: new Row(
                        children: <Widget>[
                          new Icon(Icons.inbox),
                          new SizedBox(
                            width: 5.0,
                          ),
                          new Text('Mail'),
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
                          new Icon(Icons.notifications),
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
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    showLetterList(),
                    ProfilePage(),
                    HelpPage(),
                    ContactPage(),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    showAddLetterDialog(context);
                  },
                  tooltip: 'Increment',
                  child: Icon(Icons.add),
                ))));
  }
}
