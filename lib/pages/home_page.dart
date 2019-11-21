import 'package:flutter/material.dart';
import 'package:mailman/models/letterdetails.dart';
import 'package:mailman/services/authentication.dart';
import 'package:mailman/pages/help.dart';
import 'package:mailman/pages/profile.dart';
import 'package:mailman/pages/letter.dart';
import 'package:provider/provider.dart';
import 'package:mailman/pages/letter_list.dart';

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

  @override
  void initState() {
    _tabController = new TabController(length: 4, vsync: this);
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
    return new StreamProvider<List<LetterDetails>>.value(
      // value: Letter().letters,
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: new AppBar(
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
              new RaisedButton(
                elevation: 5.0,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
                color: Colors.blue,
                child: new Text('Logout',
                    style: new TextStyle(fontSize: 20.0, color: Colors.black)),
                onPressed: () async {
                  await widget.auth.signOut();
                  widget.logoutCallback();
                },
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
          body: TabBarView(
            controller: _tabController,
            children: [
              LetterList(),
              LetterPage(),
              ProfilePage(),
              HelpPage(),
            ],
          ),
        ),
      ),
    );
  }
}
