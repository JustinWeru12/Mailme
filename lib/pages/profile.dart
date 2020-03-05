import 'package:flutter/material.dart';
import 'package:mailman/services/authentication.dart';
import 'package:mailman/models/crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:mailman/models/selectProfilPicture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mailman/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfil extends StatefulWidget {
  UserProfil({@required this.onSignOut, this.myAddress, this.myPcode});

//  final BaseAuth auth;
  final VoidCallback onSignOut;
  final String myAddress;
  final String myPcode;

  final BaseAuth auth = new Auth();

  void _signOut() async {
    try {
      await auth.signOut();
      onSignOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  State<StatefulWidget> createState() {
    return _UserProfilState(myAddress);
  }
}

class _UserProfilState extends State<UserProfil> {
  String data = "";
  String userId = 'userId';
  CrudMethods crudObj = new CrudMethods();
  String userMail = 'userMail';
  String profilPicture =
      'https://firebasestorage.googleapis.com/v0/b/lynight-53310.appspot.com/o/profilePics%2Fbloon_pics.jpg?alt=media&token=ab6c1537-9b1c-4cb4-b9d6-2e5fa9c7cb46';
  String _phone;
  String _fullNames;
  String _address;
  String _postalCode;
  String dob;
  String myAddress;
  String myPcode;
  bool _notificationValue = true;

  final _formKey = GlobalKey<FormState>();

  _UserProfilState(this.myAddress);

  void _onChangedNotification(bool value) {
    setState(() {
      _notificationValue = value;
    });
    crudObj.createOrUpdateUserData({'notification': _notificationValue});
  }

  void initState() {
    super.initState();
    widget.auth.currentUser().then((id) {
      setState(() {
        userId = id;
      });
    });
    widget.auth.userEmail().then((mail) {
      setState(() {
        userMail = mail;
      });
    });

    crudObj.getDataFromUserFromDocument().then((value) {
      Map<String, dynamic> dataMap = value.data;
      setState(() {
        _fullNames = dataMap['name'];
        profilPicture = dataMap['picture'];
        _notificationValue = dataMap['notification'];
        myAddress = dataMap['address'];
        myPcode = dataMap['postalCode'];
        
        Future<bool> saveData() async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          return await preferences.setString('myAddress', myAddress);
        }

        Future<String> loadData() async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          return preferences.getString('myAddress');
        }

        setData() {
          loadData().then((value) {
            setState(() {
              data = value;
            });
          });
        }
      });
    });
  }

  void _openModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFF737373)),
              color: Color(0xFF737373),
            ),
            child: Container(
              child: SelectProfilPicture(),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(25.0),
                  topRight: const Radius.circular(25.0),
                ),
              ),
            ),
          );
        });
  }

  String validateEmail(String value) {
    if (value.isEmpty ||
        !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
      return 'Enter a Valid email';
    } else
      return null;
  }

  String validatePhone(String value) {
    if (value.length != 10)
      return 'Enter a valid Phone Number';
    else
      return null;
  }

  String validateAddress(String value) {
    if ((value.length < 7) || !(value.contains('-')))
      return 'Enter a valid Address in the form 123..-98765';
    else
      return null;
  }

  String validatePostalCode(String value) {
    if (value.length < 5)
      return 'Enter a valid Postal Code';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          Firestore.instance.collection('user').document(userId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        var userData = snapshot.data;
        return pageConstruct(userData, context);
      },
    );
  }

  Widget userInfoTopSection(userData) {
    return Container(
      padding: EdgeInsets.only(top: 16),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Color.fromRGBO(212, 63, 141, 1),
                width: 6,
              ),
            ),
            child: GestureDetector(
              onTap: () {
//                      Navigator.push(context, MaterialPageRoute(
//                          builder: (context) => SelectProfilPicture()));
                _openModalBottomSheet(context);
              },
              child: CircleAvatar(
                // photo de profil
                backgroundImage: NetworkImage(userData['picture']),
                minRadius: 30,
                maxRadius: 93,
              ),
            ),
          ),
          Container(
            height: 15,
          ),
        ],
      ),
    );
  }

  Widget divider() {
    return Divider(
      color: Colors.blue,
      height: 15,
      indent: 70,
      endIndent: 50,
    );
  }

  Widget userBottomSection(userData) {
    Widget fullNames() {
      return ListTile(
        leading: Icon(
          Icons.person,
          color: Colors.blue,
          size: 35,
        ),
        title: Text(
          "Full Name",
          style: TextStyle(color: Colors.black, fontSize: 18.0),
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit, color: Colors.blue),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    content: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                              decoration:
                                  InputDecoration(hintText: 'Full Names'),
                              onSaved: (value) => _fullNames = value,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              color: Theme.of(context).accentColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              child: Text(
                                "Validate",
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  crudObj.createOrUpdateUserData(
                                      {'fullNames': _fullNames});
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                });
          },
        ),
        subtitle: Text(
          userData['fullNames'] ?? '',
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.black,
          ),
        ),
      );
    }

    Widget phone() {
      return ListTile(
        leading: Icon(
          Icons.supervisor_account,
          color: Colors.blue,
          size: 35,
        ),
        title: Text(
          "Phone No.",
          style: TextStyle(color: Colors.black, fontSize: 18.0),
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit, color: Colors.blue),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    content: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                              decoration: InputDecoration(hintText: 'Phone No'),
                              onSaved: (value) => _phone = value,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              color: Theme.of(context).accentColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              child: Text(
                                "Validate",
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  crudObj.createOrUpdateUserData(
                                      {'phone': _phone});
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                });
          },
        ),
        subtitle: Text(
          userData['phone'],
          style: TextStyle(fontSize: 15.0, color: Colors.black),
        ),
      );
    }

    Widget mail() {
      return ListTile(
        leading: Icon(
          Icons.mail,
          color: Colors.blue,
          size: 35,
        ),
        title: Text(
          'Mail',
          style: TextStyle(color: Colors.black, fontSize: 18.0),
        ),
        subtitle: Text(
          userMail,
          style: TextStyle(fontSize: 15.0, color: Colors.black),
        ),
      );
    }

    Widget address() {
      return ListTile(
        leading: Icon(
          FontAwesomeIcons.box,
          color: Colors.blue,
          size: 35,
        ),
        title: Text(
          "Address",
          style: TextStyle(color: Colors.black, fontSize: 18.0),
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit, color: Colors.blue),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    content: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                              validator: validateAddress,
                              decoration: InputDecoration(hintText: 'Address'),
                              keyboardType: TextInputType.number,
                              onSaved: (value) => _address = value,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              color: Theme.of(context).accentColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              child: Text(
                                "Validate",
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  crudObj.createOrUpdateUserData(
                                      {'address': _address});
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                });
          },
        ),
        subtitle: Text(
          userData['address'],
          style: TextStyle(fontSize: 15.0, color: Colors.black),
        ),
      );
    }

    Widget postalCode() {
      return ListTile(
        leading: Icon(
          FontAwesomeIcons.box,
          color: Colors.blue,
          size: 35,
        ),
        title: Text(
          "Postal Code",
          style: TextStyle(color: Colors.black, fontSize: 18.0),
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit, color: Colors.blue),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    content: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                              validator: validatePostalCode,
                              decoration:
                                  InputDecoration(hintText: 'Postal Code'),
                              keyboardType: TextInputType.number,
                              onSaved: (value) => _postalCode = value,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              color: Theme.of(context).accentColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              child: Text(
                                "Validate",
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  crudObj.createOrUpdateUserData(
                                      {'postalCode': _postalCode});
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                });
          },
        ),
        subtitle: Text(
          userData['postalCode'],
          style: TextStyle(fontSize: 15.0, color: Colors.black),
        ),
      );
    }

    Widget birth() {
      return ListTile(
        leading: Icon(
          Icons.date_range,
          color: Colors.blue,
          size: 35,
        ),
        title: Text(
          "Date of Birth",
          style: TextStyle(color: Colors.black, fontSize: 18.0),
        ),
        subtitle: Text(
          DateFormat('dd/MM/yyyy').format(userData['dob'].toDate()),
          style: TextStyle(fontSize: 15.0, color: Colors.black),
        ),
      );
    }

    Widget notification() {
      return ListTile(
        leading: Icon(
          Icons.notifications,
          color: Colors.blue,
          size: 35,
        ),
        title: Text(
          "Notification",
          style: TextStyle(color: Colors.black, fontSize: 18.0),
        ),
        trailing: Switch(
          value: _notificationValue,
          onChanged: _onChangedNotification,
          activeColor: Colors.lightBlueAccent,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(top: 5.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: FractionalOffset.center,
                    width: 460,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 16),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color.fromRGBO(251, 171, 102, 1),
                                  Color.fromRGBO(247, 65, 140, 1)
                                ]),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(25.0),
                              topRight: const Radius.circular(25.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(2.0, 5.0),
                                blurRadius: 10.0,
                              )
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                child: Column(
                                  children: <Widget>[
                                    fullNames(),
                                    divider(),
                                    phone(),
                                    divider(),
                                    mail(),
                                    divider(),
                                    address(),
                                    divider(),
                                    postalCode(),
                                    divider(),
                                    birth(),
                                    divider(),
                                    // notification(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget pageConstruct(userData, context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.0),
      resizeToAvoidBottomPadding: false,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            pinned: true,
            centerTitle: true,
            backgroundColor: Colors.white.withOpacity(0.7),
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            flexibleSpace: FlexibleSpaceBar(
              title: userData['fullNames'] == ""
                  ? Text(userMail)
                  : Text(
                      userData['fullNames'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Theme.of(context).primaryColor),
                      textAlign: TextAlign.center,
                    ),
              centerTitle: true,
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  child: userInfoTopSection(userData),
                ),
                Container(
                  child: userBottomSection(userData),
                ),
                // Container(
                //   height: 10,
                // ),
                // Container(
                //   child: FlatButton(
                //       onPressed: () {
                //         widget._signOut();
                //         Navigator.pushReplacementNamed(context, '/');
                //       },
                //       child: Text("Log out")),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
