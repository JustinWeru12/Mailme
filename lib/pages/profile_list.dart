
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mailman/models/profile_tile.dart';
import 'package:mailman/models/profiledetails.dart';

class ProfileList extends StatefulWidget {
  ProfileList({Key key}) : super(key: key);

  @override
  _ProfileListState createState() => _ProfileListState();
}

class _ProfileListState extends State<ProfileList> {
  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<List<ProfileDetails>>(context) ?? [];
    return ListView.builder(
      itemCount: profile.length,
      itemBuilder: (context, index) {
        return ProfileTile(profileDetails: profile[index]);
      },
    );
  }
}
