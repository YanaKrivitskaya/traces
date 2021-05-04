import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/colorsPalette.dart';
import 'package:traces/screens/trips/model/trip.dart';
import 'package:traces/screens/trips/tripdetails/tripMembers/bloc/tripmembers_bloc.dart';
import 'package:traces/shared/styles.dart';

class TripMembersDialog extends StatefulWidget{
  Trip trip;
  
  TripMembersDialog({@required this.trip});

  @override
  _TripMembersDialogState createState() => new _TripMembersDialogState();
}

class _TripMembersDialogState extends State<TripMembersDialog>{
  List<String> members = new List.empty();
  
  @override
  Widget build(BuildContext context) {
   return BlocBuilder<TripMembersBloc, TripMembersState>(
     builder: (context, state){
      if(state is SuccessTripMembersState){
        members = state.members;
        print(widget.trip.tripMembers);
      }
      return new AlertDialog(
        title: Text("Who's going?", style: quicksandStyle(weight: FontWeight.bold)),
        actions: [
          TextButton(
            child: Text('Done'),
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.only(left: 25.0, right: 25.0)),            
                foregroundColor: MaterialStateProperty.all<Color>(ColorsPalette.meditSea)
              ),
          ),
          TextButton(
            child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.only(left: 25.0, right: 25.0)),            
                foregroundColor: MaterialStateProperty.all<Color>(ColorsPalette.blueHorizon)
              ),
          ),
        ],
        content: SingleChildScrollView(
            child: _memberOptions(widget.trip)
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
        contentPadding: EdgeInsets.all(5.0)
      );
      
     },
   );
   
  }

  Widget _memberOptions(Trip trip) => new Column(    
    children: 
      members.map((String member)=> SizedBox(
        height: 40.0,        
        child:  CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(member),
          value: trip.tripMembers.contains(member),
          onChanged: (checked) {
            print(checked);
          },
          activeColor: ColorsPalette.meditSea       
        ),
      )).toList()
  );

}