import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mailman/services/authentication.dart';
import 'package:mailman/style/theme.dart' as Theme;
import 'package:mailman/models/user.dart';
import 'package:mailman/models/crud.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:mailman/models/primary_button.dart';

class LoginSignUpPage extends StatefulWidget {
  LoginSignUpPage({Key key, this.auth, this.loginCallback, this.title})
      : super(key: key);

  final String title;
  final BaseAuth auth;
  final VoidCallback loginCallback;
  @override
  _LoginSignUpPageState createState() => _LoginSignUpPageState();
}

enum FormType { login, register }

class _LoginSignUpPageState extends State<LoginSignUpPage>
    with TickerProviderStateMixin {
  static final _formKey = new GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  CrudMethods crudObj = new CrudMethods();
  String _email;
  String _fullNames;
  DateTime dob;
  File picture;
  // String _address;
  // String _postalCode;
  String _authHint = '';
  FormType _formType = FormType.login;
  String _password;
  // String _errorMessage;

  // bool _isLoginForm;
  bool _isLoading;
  Color dobColor = Colors.blue[800];
  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void validateAndSubmit() async {
    if (validateAndSave()) {
      setState(() {
        _isLoading = true;
      });
      try {
        String userId = _formType == FormType.login
            ? await widget.auth.signIn(_email, _password)
            : await widget.auth.signUp(_email, _password);
        setState(() {
          _isLoading = false;
        });
        if (_formType == FormType.register) {
          UserData userData = new UserData(
            fullNames: _fullNames,
            email: _email,
            phone: "",
            picture: "https://firebasestorage.googleapis.com/v0/b/lynight-53310.appspot.com/o/profilePics%2Fbloon_pics.jpg?alt=media&token=ab6c1537-9b1c-4cb4-b9d6-2e5fa9c7cb46",
            address: "",
            postalCode: "",
            dob: dob,
          );
          crudObj.createOrUpdateUserData(userData.getDataMap());
        }

        if (userId == null) {
          print("EMAIL NOT VERIFIED");
          setState(() {
            _authHint = 'Check your email 🙂';
            _isLoading = false;
            _formType = FormType.login;
          });
        } else {
          _isLoading = false;
          widget.loginCallback();
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
          _authHint = 'connection error\n\n${e.toString()}';
        });
        print(e);
      }
    } else {
      setState(() {
        _authHint = '';
      });
    }
  }

  void moveToRegister() {
    _formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
      _authHint = '';
    });
  }

  void moveToLogin() {
    _formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
      _authHint = '';
    });
  }

  Widget _buildEmailField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        key: new Key('email'),
        decoration: InputDecoration(
          labelText: 'Email',
          icon: new Icon(
            Icons.mail,
            color: Colors.blue,
          ),
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(15.0),
            borderSide: new BorderSide(),
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (String value) {
          if (value.isEmpty ||
              !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                  .hasMatch(value)) {
            return 'Enter a valid email';
          }
        },
        onSaved: (value) => _email = value,
      ),
    );
  }

  Widget _buildNameField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        key: new Key('namefield'),
        decoration: InputDecoration(
          labelText: 'Full Name',
          icon: new Icon(
            Icons.perm_identity,
            color: Colors.blue,
          ),
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(15.0),
            borderSide: new BorderSide(),
          ),
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Enter your Name';
          }
        },
        onSaved: (value) => _fullNames = value,
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        key: new Key('password'),
        decoration: InputDecoration(
          labelText: 'Password',
          icon: new Icon(
            Icons.lock,
            color: Colors.blue,
          ),
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(15.0),
            borderSide: new BorderSide(),
          ),
        ),
        controller: _passwordTextController,
        obscureText: true,
        validator: (String value) {
          if (value.isEmpty || value.length < 6) {
            return 'Enter a minimum of 6 characters';
          }
        },
        onSaved: (value) => _password = value,
      ),
    );
  }

  Widget _builConfirmPasswordTextField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Confirm Password',
          icon: new Icon(
            Icons.lock,
            color: Colors.blue,
          ),
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(15.0),
            borderSide: new BorderSide(),
          ),
        ),
        obscureText: true,
        validator: (String value) {
          if (_passwordTextController.text != value) {
            return 'Passwords don\'t correspond';
          }
        },
      ),
    );
  }

  Widget _showDatePicker() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.date_range,
            color: Colors.blue,
          ),
          FlatButton(
            onPressed: () {
              DatePicker.showDatePicker(
                context,
                showTitleActions: true,
                minTime: DateTime(1968, 1, 1),
                maxTime: DateTime(2002, 3, 7),
                onConfirm: (date) {
                  setState(() {
                    dob = date;
                    dobColor = Colors.blue[600];
                  });
                },
                currentTime: DateTime.now(),
                locale: LocaleType.en,
              );
            },
            child: Text(
              dob == null
                  ? 'Date of Birth'
                  : DateFormat('dd/MM/yyyy').format(dob),
              style: TextStyle(color: dobColor, fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget submitWidgets() {
    switch (_formType) {
      case FormType.login:
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            PrimaryButton(
              key: new Key('login'),
              text: 'Login',
              height: 44.0,
              onPressed: validateAndSubmit,
            ),
            FlatButton(
                key: new Key('need-account'),
                child: Text("Create a New Account"),
                onPressed: moveToRegister),
          ],
        );
      default:
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            PrimaryButton(
                key: new Key('register'),
                text: 'Sign Up',
                height: 44.0,
                onPressed: () {
                  if (dob == null) {
                    validateAndSave();
                    setState(() {
                      dobColor = Colors.red[700];
                    });
                  } else {
                    validateAndSubmit();
                  }
                }),
            FlatButton(
                key: new Key('need-login'),
                child: Text("Already Have an Account ? Login"),
                onPressed: moveToLogin),
          ],
        );
    }
  }

  Widget _showCircularProgress() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _showLogo() {
    return Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: Container(
          height: 200,
          width: 500,
          child: Hero(
            tag: 'hero',
            child: Padding(
              padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 70.0,
                child: Image.asset('assets/login_logo.png'),
              ),
            ),
          ),
        ));
  }

  Widget hintText() {
    return Container(
        //height: 80.0,
        padding: const EdgeInsets.all(32.0),
        child: Text(_authHint,
            key: new Key('hint'),
            style: TextStyle(fontSize: 18.0, color: Colors.grey),
            textAlign: TextAlign.center));
  }

  Widget _buildForm() {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _showLogo(),
            SizedBox(
              height: 10.0,
            ),
            _formType == FormType.register ? _buildNameField() : Container(),
            _buildEmailField(),
            SizedBox(
              height: 10.0,
            ),
            _buildPasswordField(),
            SizedBox(
              height: 10.0,
            ),
            _formType == FormType.register
                ? _builConfirmPasswordTextField()
                : Container(),
            SizedBox(
              height: 10.0,
            ),
            _formType == FormType.register ? _showDatePicker() : Container(),
            SizedBox(
              height: 10.0,
            ),
            _isLoading != false ? submitWidgets() : _showCircularProgress()
          ],
        ));
  }

  Widget padded({Widget child}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Center(
          child: Text(
            widget.title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      backgroundColor: Colors.white,
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
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: <Widget>[
                Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
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
                          child: _buildForm(),
                        )),
                  ),
                ]),
                hintText(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
