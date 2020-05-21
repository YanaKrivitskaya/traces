import 'package:flutter/material.dart';
import 'package:traces/auth/bloc.dart';
import 'package:traces/colorsPalette.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileView extends StatefulWidget{

  ProfileView();
  State<ProfileView> createState() => _ProfileViewState();

}

class _ProfileViewState extends State<ProfileView>{
  @override
  Widget build(BuildContext context) {
   return Container(
     padding: EdgeInsets.all(10.0),
     child: Column(
       children: <Widget>[
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
           children: <Widget>[
             CircleAvatar(
                 backgroundColor: ColorsPalette.lynxWhite,
                 child: Text("YK", style: TextStyle(color: ColorsPalette.meditSea, fontSize: 40.0, fontWeight: FontWeight.w300),),
                 radius: 50.0
             ),
             Container(
               //alignment: Alignment.center,
               padding: EdgeInsets.all(10.0),
               child: Column(
                 children: <Widget>[
                   Text("Yana Krivitskaya", style: TextStyle(fontSize: 20.0))
                 ],
               ),
             ),
           ],
         ),
         Container(
           padding: EdgeInsets.only(right: 10.0, left: 10.0),
           alignment: Alignment.centerLeft,
           child: Row(children: <Widget>[
             Text("Email: yani.krivitskaya@gmail.com", style: TextStyle(fontSize: 15.0)),
             IconButton(icon: Icon(Icons.error_outline, color: ColorsPalette.fusionRed), tooltip: 'Not verified'),
             //IconButton(icon: Icon(Icons.check, color: ColorsPalette.meditSea), tooltip: 'Verified'),
           ],),
         ),
         /*Align(
           alignment: Alignment.centerLeft,
           child: FlatButton(
             color: ColorsPalette.fusionRed,
             child: Text("Verify email", style: TextStyle(color: ColorsPalette.lynxWhite),),
             onPressed: (){},
           ),
         ),*/
         Divider(color: ColorsPalette.meditSea,),
         Container(
           padding: EdgeInsets.only(right: 10.0, left: 10.0),
           alignment: Alignment.centerLeft,
           child: Column(
             children: <Widget>[
               Align(
                 alignment: Alignment.centerLeft,child: Text("Family:", style: TextStyle(fontSize: 20.0, color: ColorsPalette.meditSea)),
               ),
               ListTile(
                 title: Text("YK"),
                 trailing: Icon(Icons.arrow_forward_ios, size: 15.0),
               ),

               ListTile(
                 title: Text("SP"),
                 trailing: Icon(Icons.arrow_forward_ios, size: 15.0),
               ),
               Align(
                 alignment: Alignment.centerLeft,child: OutlineButton(child: Text("Add...", style: TextStyle(color: ColorsPalette.fusionRed),))
               ),
             ],
           ),
         ),

         Expanded(
           child: Align(
               alignment: FractionalOffset.bottomCenter,
               child: Container(
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.end,
                   children: <Widget>[
                     Divider(color: ColorsPalette.meditSea),
                     OutlineButton(
                       child: ListTile(
                           leading: Icon(Icons.exit_to_app, color: ColorsPalette.fusionRed),
                           title: Text('Sign out')),
                       onPressed: (){
                         BlocProvider.of<AuthenticationBloc>(context).add(
                             LoggedOut()
                         );
                         Navigator.of(context).pushNamedAndRemoveUntil(Navigator.defaultRouteName, (Route<dynamic> route) => false);
                       },
                     ),
                   ],
                 ),
               )
           ),
         )
       ],
     ),
   );
  }
}