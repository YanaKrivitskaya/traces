import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../constants/color_constants.dart';
import '../../widgets/widgets.dart';
import 'model/group_model.dart';
import 'model/group_user_model.dart';

class VerticalUserListItem extends StatelessWidget {
  VerticalUserListItem(this.group, this.user);
  final Group group;
  final GroupUser user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>{},
        /*Slidable.of(context)?.animation? == SlidableRenderingMode.none
          ? Slidable.of(context)?.open()
          : Slidable.of(context)?.close(),*/
      child: InkWell(
        child: ListTile(
          leading: avatar(user.name, 20.0, ColorsPalette.meditSea, 15.0),
          title: Text(user.name),
          //trailing: EditFamilyButton(user, group.id!),
        ),
        onTap: () {
          /*showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) => BlocProvider<EntryExitBloc>(
              create: (context) => EntryExitBloc(/*visasRepository: new FirebaseVisasRepository()*/)
                ..add(GetEntryDetails(item, visa)),
              child: EntryExitDetailsView()));*/
      })
    );
  }
}