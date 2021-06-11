import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/colorsPalette.dart';
import 'package:traces/screens/profile/model/member.dart';
import 'package:traces/screens/trips/model/trip.dart';
import 'package:traces/screens/trips/tripdetails/tripMembers/bloc/tripmembers_bloc.dart';
import 'package:traces/shared/shared.dart';
import 'package:traces/shared/styles.dart';

class TripMembersDialog extends StatefulWidget{
  Trip trip;
  
  TripMembersDialog({@required this.trip});

  @override
  _TripMembersDialogState createState() => new _TripMembersDialogState();
}

class _TripMembersDialogState extends State<TripMembersDialog>{
  /*List<Member> members = new List.empty();
  List<String> selectedMembers = new List.empty(growable: true);*/
  
  @override
  Widget build(BuildContext context) {
   return BlocListener<TripMembersBloc, TripMembersState>(
     listener: (context, state){       
       if(state is SubmittedTripMembersState){
          Navigator.pop(context);
        }
     },
     child: BlocBuilder<TripMembersBloc, TripMembersState>(
      builder: (context, state){
        if(state is LoadingTripMembersState){
          return loadingWidget(ColorsPalette.blueMartina);
        }
        return new AlertDialog(
          title: Text("Who's going?", style: quicksandStyle(weight: FontWeight.bold)),
          actions: [
            TextButton(
              child: Text('Done'),
                onPressed: () {
                  context.read<TripMembersBloc>().add(SubmitTripMembers(widget.trip.id, state.selectedMembers));
                  //Navigator.pop(context);
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
              child: _memberOptions(state)
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))
          ),
          contentPadding: EdgeInsets.all(5.0)
        );
        
      },
    )
   );
   
  }

  Widget _memberOptions(TripMembersState state) => new Column(    
    children: 
      state.members.map((Member member)=> SizedBox(
        height: 40.0,        
        child:  CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(member.name),
          value: state.selectedMembers.contains(member.id),
          onChanged: (checked) {
            context.read<TripMembersBloc>().add(MemberChecked(member.id, checked));
          },
          activeColor: ColorsPalette.meditSea       
        ),
      )).toList()
  );

}