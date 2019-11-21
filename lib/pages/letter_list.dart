import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mailman/models/letter_tile.dart';
import 'package:mailman/models/letterdetails.dart';

class LetterList extends StatefulWidget {
  LetterList({Key key}) : super(key: key);

  @override
  _LetterListState createState() => _LetterListState();
}

class _LetterListState extends State<LetterList> {
  @override
  Widget build(BuildContext context) {
    final letters = Provider.of<List<LetterDetails>>(context) ?? [];
    return ListView.builder(
      itemCount: letters.length,
      itemBuilder: (context, index) {
        return LetterTile(letterDetails: letters[index]);
      },
    );
  }
}
