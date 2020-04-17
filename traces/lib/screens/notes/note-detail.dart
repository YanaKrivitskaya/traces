import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traces/Models/noteModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:traces/services/noteFireService.dart';
import '../../colorsPalette.dart';
import 'package:intl/intl.dart';

class NoteDetailsPageArguments {
  final NoteModel note;

  NoteDetailsPageArguments(this.note);
}

class NoteDetailsPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return new _NotesDetailsPageState();
  }
}

class _NotesDetailsPageState extends State<NoteDetailsPage>{

  final NoteFireService noteService = new NoteFireService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    final NoteDetailsPageArguments arguments = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _deleteAlert(arguments.note).then((res){
                if(res == "Delete") Navigator.of(context).pop();
              });
            },
          ),
        ],
        backgroundColor: ColorsPalette.greenGrass,
      ),
      body: Container(child: Column(children: <Widget>[
        Card(
            child: Column(
              children: <Widget>[
                ListTile(
                    title: Text('${arguments.note.title}', style: new TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Created: ${DateFormat.yMMMd().format(arguments.note.dateCreated)} | Modified: ${DateFormat.yMMMd().format(arguments.note.dateModified)}' ),
                )
              ],
            )
        ),
        Card(
            child: Column(
              children: <Widget>[
                ListTile(
                    title: Text('${arguments.note.text}'),
                  contentPadding: EdgeInsets.all(10.0)
                )
              ],
            )
        )
      ])
      )
    );
  }

  Future<String> _deleteAlert(NoteModel note) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete note?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('${note.title}'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Delete'),
              onPressed: () {
                _deleteNote(context, note.id);
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, "Cancel");
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteNote(BuildContext context, String id) async{
    noteService.deleteNote(id).then((data){
      Navigator.pop(context, "Delete");
    });
  }

}