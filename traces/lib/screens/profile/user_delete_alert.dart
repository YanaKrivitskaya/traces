import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/color_constants.dart';
import 'bloc/profile/bloc.dart';
import 'model/group_model.dart';
import 'model/group_user_model.dart';

class UserDeleteAlert extends StatelessWidget {
  final GroupUser user;
  final Group group;
  const UserDeleteAlert({Key? key, required this.user, required this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      bloc: BlocProvider.of(context),
      builder: (context, state){
        return AlertDialog(
          title: Text("Delete user from group"),
          content: SingleChildScrollView(            
            child: Column( crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Delete user ${user.name} from ${group.name}?')
              ],
            )
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Delete', style: TextStyle(color: ColorsPalette.mazarineBlue)),
              onPressed: () {
                context.read<ProfileBloc>().add(UserRemovedFromGroup(user: user, group: group));                
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Cancel', style: TextStyle(color: ColorsPalette.mazarineBlue),),
              onPressed: () {                
                Navigator.pop(context);
              },
            ),
          ],
        );
      }
    );
  }
}
