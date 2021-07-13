import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/route_constants.dart';
import '../../../widgets/widgets.dart';
import '../bloc/visa_details/visa_details_bloc.dart';
import '../model/visa.model.dart';

class VisaDeleteAlert extends StatelessWidget {
  final Visa? visa;
  final StringCallback? callback;

  const VisaDeleteAlert({Key? key, this.visa, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VisaDetailsBloc, VisaDetailsState>(
      bloc: BlocProvider.of(context),
      builder: (context, state){
        return AlertDialog(
          title: Text("Delete Visa?"),
          content: SingleChildScrollView(            
            child: Column( crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${visa!.country} - ${visa!.type}'),
                Text('${DateFormat.yMMMd().format(visa!.startDate!)} - ${DateFormat.yMMMd().format(visa!.endDate!)}'),
                Divider(color: ColorsPalette.algalFuel,),
                Text('All visa entries will be deleted')
              ],
            )
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Delete', style: TextStyle(color: ColorsPalette.mazarineBlue)),
              onPressed: () {
                context.read<VisaDetailsBloc>().add(DeleteVisaClicked(visa!.id));
                callback!("Delete");
                Navigator.of(context).pushReplacementNamed(visasRoute);
              },
            ),
            TextButton(
              child: Text('Cancel', style: TextStyle(color: ColorsPalette.mazarineBlue),),
              onPressed: () {
                callback!("Cancel");
                Navigator.pop(context);
              },
            ),
          ],
        );
      }
    );
  }
}
