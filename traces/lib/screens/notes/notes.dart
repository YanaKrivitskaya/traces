import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traces/Models/noteModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:traces/services/noteFireService.dart';
import '../../colorsPalette.dart';
import 'package:intl/intl.dart';

class NotesPage extends StatefulWidget{
  //String uid = await auth.getUserId();


  @override
  State<StatefulWidget> createState() {
    return new _NotesPageState();
  }
}

class _NotesPageState extends State<NotesPage>{
  List<NoteModel> notes;
  StreamSubscription<QuerySnapshot> noteSub;
  final NoteFireService noteService = new NoteFireService();

  @override
  void initState() {
    notes = new List();
    noteSub?.cancel();
    noteSub = noteService.getNotes().listen((QuerySnapshot snapshot){
      final List<NoteModel> items = snapshot.documents
          .map((documentSnapshot) => NoteModel.fromMap(documentSnapshot.data)).toList();
      setState(() {
        this.notes = items;
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
      body: SingleChildScrollView(child: Column(
        children: <Widget>[
          Container(
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: notes.length,
                  itemBuilder: (context, position){
                    return Card(
                      child: ListTile(
                        leading: Icon(Icons.description, size: 40.0, color: ColorsPalette.nycTaxi,),
                        title: Text('${notes[position].title}'),
                        subtitle: Text('Created: ${DateFormat.yMMMd().format(notes[position].dateCreated)}'),
                        //subtitle: Text('Description can be here'),
                        trailing: Icon(Icons.more_vert),
                      ),
                    );
                  }
              )
          )],)),
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
      await noteService.createNote("New Note #xxx", "text of new note. Awesome text, just the best texte ever.");
  }

}