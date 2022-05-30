import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/constants/color_constants.dart';
import 'package:traces/screens/settings/categories/bloc/categories_bloc.dart';
import 'package:traces/screens/settings/model/category.model.dart';
import 'package:traces/utils/style/styles.dart';
import 'package:traces/widgets/widgets.dart';

class CategoryEditDialog extends StatefulWidget {

  //final Trip? trip;
  final StringCallback? callback;

  const CategoryEditDialog({Key? key, this.callback}) : super(key: key);

   @override
  _CategoryEditDialogState createState() => new _CategoryEditDialogState();
}

class _CategoryEditDialogState extends State<CategoryEditDialog>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Category? category;
  TextEditingController? _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = new TextEditingController(); 
  }

  @override
  void dispose() {
    _nameController!.dispose();    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoriesBloc, CategoriesState>(
      listener: (context, state) {
        
      },
      child: BlocBuilder<CategoriesBloc, CategoriesState>(
        builder: (context, state) {
          return AlertDialog(
            insetPadding: EdgeInsets.all(30.0),
            title: Text("Category"),
            content: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(            
                child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                  children: [  
                    Form(
                      key: _formKey,
                      child: _categoryDetailsForm(state),
                    )                  
                  ],
                )
              )
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Done', style: TextStyle(color: ColorsPalette.meditSea)),
                onPressed: () {
                                
                },
              ),
              TextButton(
                child: Text('Cancel', style: TextStyle(color: ColorsPalette.meditSea),),
                onPressed: () {
                  //widget.callback!(null);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      )
    );
  }

  Widget _categoryDetailsForm(CategoriesState state) => new Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Name', style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)), 
      TextFormField(
        decoration: InputDecoration(
          isDense: true,                      
          hintText: "e.g., Tickets"                      
        ),
        style:  quicksandStyle(fontSize: 18.0),
        controller: _nameController,
        keyboardType: TextInputType.text,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {                        
          return value!.isEmpty ? 'Required field' : null;
        }
      ),
      SizedBox(height: 20.0,),
    ],
  );

}