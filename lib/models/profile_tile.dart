import 'package:mailman/models/profiledetails.dart';
import 'package:flutter/material.dart';


class ProfileTile extends StatelessWidget {

  final ProfileDetails profileDetails;
  ProfileTile({this.profileDetails });

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
          title: Text(profileDetails.fullNames),
          subtitle: Text('Email: ${profileDetails.email}\n PhoneNo: ${profileDetails.phone}\n Address: ${profileDetails.address}'),
        ),
      ),
    );
  }
}