import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traces/Models/noteModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:traces/constants.dart';
import 'package:traces/services/noteFireService.dart';
import '../../colorsPalette.dart';
import 'package:intl/intl.dart';

enum SortOptions{
  TITLE,
  DATECREATED,
  DATEMODIFIED
}

enum OrderOptions{
  ASC,
  DESC
}

class SortOption{
  final SortOptions _key;
  final String _value;
  SortOption(this._key, this._value);
}
class OrderOption{
  final OrderOptions _key;
  final String _value;
  OrderOption(this._key, this._value);
}

class SortOrder{
  SortOptions _sortOption;
  OrderOptions _orderOption;
  SortOrder(this._sortOption, this._orderOption);
}

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

  SortOptions _sortOption = SortOptions.DATECREATED;
  OrderOptions _orderOption = OrderOptions.ASC;

  bool _isLoading = false;

  @override
  void initState() {
    notes = new List();
    noteSub?.cancel();
    _isLoading = true;
    noteSub = noteService.getNotes().listen((QuerySnapshot snapshot){
      final List<NoteModel> items = snapshot.documents
          .map((documentSnapshot) => NoteModel.fromMap(documentSnapshot.data)).toList();
      setState(() {
        this.notes = items;
        this.itemsLength = items.length;
        _sortOption = SortOptions.DATECREATED;
        _orderOption = OrderOptions.ASC;
        _isLoading = false;
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
        title: Text('Notes', style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.grayLight, fontSize: 40.0))),
        centerTitle: true,
        backgroundColor: ColorsPalette.greenGrass,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: (){
              showDialog(barrierDismissible: false, context: context,builder: (_) =>
                  SortDialog(initialSortOption: _sortOption, initialOrderOption: _orderOption,) ).then((res){
                    if(res != null) setState(() {
                      _sortOption = res._sortOption;
                      _orderOption = res._orderOption;
                    });
                  });
            },
          )
        ],
      ),
      body: Container(
          padding: EdgeInsets.only(bottom: 65.0),
          child: !_isLoading ? SingleChildScrollView(child: Column(
            children: <Widget>[
              itemsLength > 0 ?
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
              ) : Center(child: Text("No notes here"))
            ],))
              : CircularProgressIndicator()
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
      await Navigator.pushNamed(context, noteDetailsRoute, arguments: '');
  }

  void _navigateToNote(BuildContext context, NoteModel note) async{
    await Navigator.pushNamed(context, noteDetailsRoute, arguments: note.id);
  }

  void _deleteNote(NoteModel note, BuildContext context) async{
    await noteService.deleteNote(note.id).then((data){
      Navigator.pop(context, "Delete");
    });
  }


  Widget _popupMenu(NoteModel note, int position) => PopupMenuButton<int>(
    itemBuilder: (context) => [
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

class SortDialog extends StatefulWidget {
  SortDialog({this.initialSortOption, this.initialOrderOption});

  final SortOptions initialSortOption;
  final OrderOptions initialOrderOption;

  @override
  _SortDialogState createState() => new _SortDialogState();
}

class _SortDialogState extends State<SortDialog>{
  SortOptions _selectedSortOption;
  OrderOptions _selectedOrderOption;

  final _sortOptionsList = [
    SortOption(SortOptions.TITLE, "Title"),
    SortOption(SortOptions.DATECREATED, "Date Created"),
    SortOption(SortOptions.DATEMODIFIED, "Date Modified"),
  ];

  final _orderOptionsLst = [
    OrderOption(OrderOptions.ASC, "Ascending"),
    OrderOption(OrderOptions.DESC, "Descending")
  ];

  @override
  void initState() {
    super.initState();
    _selectedSortOption = widget.initialSortOption;
    _selectedOrderOption = widget.initialOrderOption;
  }

  @override
  Widget build(BuildContext context){
    return new AlertDialog(
      title: Text('Sort by'),
      actions: <Widget>[
        FlatButton(
          child: Text('Done'),
          onPressed: () {Navigator.pop(context, new SortOrder(_selectedSortOption, _selectedOrderOption));},
        ),
        FlatButton(
          child: Text('Cancel'),
          onPressed: () {Navigator.pop(context, new SortOrder(widget.initialSortOption, widget.initialOrderOption));},
        ),
      ],
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _sortOptions(),
            Divider(color: ColorsPalette.blueHorizon),
            _orderOptions()
          ],
        ),
      ),
    );
  }

   Widget _sortOptions() => new Column(
      children:
        _sortOptionsList.map((SortOption option) => RadioListTile(
          groupValue: _selectedSortOption,
          title: Text(option._value),
          value: option._key,
          onChanged: (val) {
            setState(() {
              _selectedSortOption = val;
            });
          },
        )).toList(),
      //]
  );

  Widget _orderOptions() => new Column(
    children:
    _orderOptionsLst.map((OrderOption option) => RadioListTile(
      groupValue: _selectedOrderOption,
      title: Text(option._value),
      value: option._key,
      onChanged: (val) {
        setState(() {
          _selectedOrderOption = val;
        });
      },
    )).toList(),
    //]
  );
}