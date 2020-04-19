import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traces/Models/noteModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:traces/constants.dart';
import 'package:traces/screens/notes/note-detail.dart';
import 'package:traces/services/noteFireService.dart';
import '../../colorsPalette.dart';
import 'package:intl/intl.dart';

class NotesPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return new _NotesPageState();
  }
}

class _NotesPageState extends State<NotesPage>{
  List<NoteModel> notes;
  StreamSubscription<QuerySnapshot> noteSub;
  final NoteFireService noteService = new NoteFireService();

  int itemsLength = 0;

  @override
  void initState() {
    notes = new List();
    noteSub?.cancel();
    noteSub = noteService.getNotes().listen((QuerySnapshot snapshot){
      final List<NoteModel> items = snapshot.documents
          .map((documentSnapshot) => NoteModel.fromMap(documentSnapshot.data)).toList();
      setState(() {
        this.notes = items;
        this.itemsLength = items.length;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    noteSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notes',
          style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.grayLight, fontSize: 40.0))
        ),
        centerTitle: true,
        backgroundColor: ColorsPalette.greenGrass,
      ),
      body: Container(
          padding: EdgeInsets.only(bottom: 65.0),
          child: SingleChildScrollView(child: Column(
            children: <Widget>[
              Container(
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: itemsLength,
                      itemBuilder: (context, position){
                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.description, size: 40.0, color: ColorsPalette.nycTaxi,),
                            title: Text('${notes[position].title}'),
                            subtitle: Text('Created: ${DateFormat.yMMMd().format(notes[position].dateCreated)}'),
                            trailing: _popupMenu(notes[position], position),
                            onTap: (){
                              _navigateToNote(context, notes[position]);
                            },
                          ),
                        );
                      }
                  )
              )],))
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _addNewNote();
        },
        tooltip: 'Add',
        backgroundColor: ColorsPalette.nycTaxi,
        child: Icon(Icons.add, color: ColorsPalette.grayLight),
      ),
    );
  }

  void _addNewNote() async{
      await noteService.createNote("New Note #xxx", "text of new note. Awesome text, just the best text ever.");
  }

  void _navigateToNote(BuildContext context, NoteModel note) async{
    await Navigator.pushNamed(context, noteDetailsRoute, arguments: note.id);
  }

  void _deleteNote(NoteModel note, BuildContext context) async{
    await noteService.deleteNote(note.id).then((data){
      Navigator.pop(context, "Delete");
      setState(() {
        /*this.notes.removeAt(this.notes.indexOf(note));
        this.itemsLength = this.notes.length;*/
      });
    });
  }

  Widget _popupMenu(NoteModel note, int position) => PopupMenuButton<int>(
    itemBuilder: (context) => [
      PopupMenuItem(
        value: 1,
        child: Text(
          "Edit",
          style:
          TextStyle(color: ColorsPalette.blueHorizon, fontWeight: FontWeight.w700),
        ),
      ),
      PopupMenuItem(
        value: 2,
        child: Text(
          "Delete",
          style:
          TextStyle(color: ColorsPalette.blueHorizon, fontWeight: FontWeight.w700),
        ),
      ),
    ],
    onSelected: (value) async{
      if(value == 2){
        _deleteAlert(note).then((res){});
      }
      print("value:$value");
    },
    //elevation: 4,
    //padding: EdgeInsets.symmetric(horizontal: 50),
  );

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
                _deleteNote(note, context);
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

}