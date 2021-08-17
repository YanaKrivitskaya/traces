import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/constants/color_constants.dart';
import 'package:traces/screens/profile/model/group_user_model.dart';
import 'package:traces/screens/trips/model/trip.model.dart';
import 'package:traces/screens/trips/tripdetails/tripMembers/bloc/tripmembers_bloc.dart';
import 'package:traces/utils/style/styles.dart';
import 'package:traces/widgets/widgets.dart';

class TripMembersDialog extends StatefulWidget{
  Trip trip;
  final StringCallback? callback;
  
  TripMembersDialog({required this.trip, this.callback});

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
          Navigator.pop(context, true);
          widget.callback!("Update");
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
                  context.read<TripMembersBloc>().add(SubmitTripMembers(widget.trip.id!, state.selectedMembers));
                  //Navigator.pop(context, 'Update');
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
      state.members.map((GroupUser member)=> SizedBox(
        height: 40.0,        
        child:  CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(member.name),
          value: state.selectedMembers?.contains(member.userId),
          onChanged: (checked) {
            context.read<TripMembersBloc>().add(MemberChecked(member.userId, checked));
          },
          activeColor: ColorsPalette.meditSea       
        ),
      )).toList()
  );

}