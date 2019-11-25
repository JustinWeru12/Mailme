import 'package:mailman/models/letterdetails.dart';
import 'package:flutter/material.dart';


class LetterTile extends StatelessWidget {

  final LetterDetails letterDetails;
  LetterTile({this.letterDetails });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.brown[300],
            backgroundImage: AssetImage('assets/login_logo.png'),
          ),
          title: Text(letterDetails.trackingNo),
          subtitle: Text('Your letter ${letterDetails.trackingNo} was ${letterDetails.status}'),
        ),
      ),
    );
  }
}