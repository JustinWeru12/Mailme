import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mailman/style/theme.dart' as Theme;
import 'package:mailman/models/crud.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String fullNames;
  String email;
  String phone;
  String age;
  String address;
  CrudMethods crudObj = new CrudMethods();
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
        child: Stack(
          children: <Widget>[
            _createProfile(),
          ],
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
            title: Text('Profile Added',
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

  Widget _createProfile() {
    return new Card(
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
                  hintText: 'John Doe',
                  hintStyle: TextStyle(
                      fontFamily: "WorkSansSemiBold",
                      fontSize: 17.0,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey),
                  icon: new Icon(
                    FontAwesomeIcons.solidUser,
                    color: Colors.blue,
                  ),
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(),
                  ),
                ),
                onChanged: (value) {
                  this.fullNames = value;
                },
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
                  hintText: 'name@example.com',
                  hintStyle: TextStyle(
                      fontFamily: "WorkSansSemiBold",
                      fontSize: 17.0,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey),
                  icon: new Icon(
                    FontAwesomeIcons.at,
                    color: Colors.blue,
                  ),
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(),
                  ),
                ),
                onChanged: (value) {
                  this.email = value;
                },
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
                  hintText: '+254712345678',
                  hintStyle: TextStyle(
                      fontFamily: "WorkSansSemiBold",
                      fontSize: 17.0,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey),
                  icon: new Icon(
                    FontAwesomeIcons.solidAddressBook,
                    color: Colors.blue,
                  ),
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(),
                  ),
                ),
                onChanged: (value) {
                  this.phone = value;
                },
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
                  hintStyle:
                      TextStyle(fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                  icon: new Icon(
                    FontAwesomeIcons.githubAlt,
                    color: Colors.blue,
                  ),
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(),
                  ),
                ),
                onChanged: (value) {
                  this.age = value;
                },
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
                  hintText: '123-12345',
                  hintStyle: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 17.0,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  icon: new Icon(
                    FontAwesomeIcons.solidEnvelopeOpen,
                    color: Colors.blue,
                  ),
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(),
                  ),
                ),
                onChanged: (value) {
                  this.address = value;
                },
              ),
              SizedBox(
                height: 25.0,
              ),
              // TextField(
              //   style: TextStyle(
              //       fontFamily: "WorkSansSemiBold",
              //       fontSize: 16.0,
              //       color: Colors.black),
              //   autofocus: false,
              //   decoration: new InputDecoration(
              //     labelText: 'Postal Code.',
              //     hintStyle: TextStyle(
              //         fontFamily: "WorkSansSemiBold", fontSize: 17.0),
              //     icon: new Icon(
              //       FontAwesomeIcons.boxOpen,
              //       color: Colors.blue,
              //     ),
              //     border: new OutlineInputBorder(
              //       borderRadius: new BorderRadius.circular(25.0),
              //       borderSide: new BorderSide(),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 25.0,
              // ),
              RaisedButton(
                elevation: 5.0,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                color: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                  crudObj.addData({
                    'fullNames': this.fullNames,
                    'email': this.email,
                    'phone': this.phone,
                    'age': this.age,
                    'address': this.address
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
    );
  }
}
