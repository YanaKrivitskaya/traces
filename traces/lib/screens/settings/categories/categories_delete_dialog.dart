import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/constants/color_constants.dart';
import 'package:traces/screens/settings/categories/bloc/categories_bloc.dart';
import 'package:traces/screens/settings/model/category-usage.model.dart';
import 'package:traces/screens/settings/model/category.model.dart';
import 'package:traces/utils/style/styles.dart';
import 'package:traces/widgets/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CategoriesDeleteDialog extends StatefulWidget{
  final Category category;
  final StringCallback? callback;

  CategoriesDeleteDialog({required this.category, this.callback});

  @override
  _CategoriesDeleteDialogViewState createState() => _CategoriesDeleteDialogViewState();

}

class _CategoriesDeleteDialogViewState extends State<CategoriesDeleteDialog>{
  TextEditingController? _categoryController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

   @override
  void initState() {
    super.initState();   
    _categoryController = new TextEditingController();    
 
  }

  /*@override
  void dispose() {    
    _categoryController!.dispose();    
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    CategoryUsage? categoryUsage;
    late String errorText;
    bool showError = false;
    
    return BlocListener<CategoriesBloc, CategoriesState>(
      listener: (context, state) {
        if(state is CategoryToDelete){
          showError = false;
          categoryUsage = state.categoryUsage;
        }
        if(state is CategoryUpdatedState){
          widget.callback!('Ok');
          Navigator.pop(context);
        }
        if(state is CategoriesError){
          showError = true;
          errorText = state.error;
        }
      },
      child: BlocBuilder<CategoriesBloc, CategoriesState>(
        builder: (context, state) {
          return AlertDialog(
            title: Text("Delete category?"),
            content: SingleChildScrollView(
              child: Column(children: [
                Row(children: [
                  Text("Name: ", style: quicksandStyle(weight: FontWeight.bold)),
                  Text(widget.category.name!)
                ],),
                categoryUsage != null ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Divider(color: ColorsPalette.amMint),
                  Text("Category is in use: ", style: quicksandStyle(weight: FontWeight.bold)),
                  Row(children: [
                    Text("Activities: ", style: quicksandStyle(weight: FontWeight.bold)),
                    Text(categoryUsage!.activitiesCount.toString())
                  ],),
                  Row(children: [
                    Text("Expenses: ", style: quicksandStyle(weight: FontWeight.bold)),
                    Text(categoryUsage!.expensesCount.toString())
                  ],),
                  categoryUsage!.activitiesCount > 0 || categoryUsage!.expensesCount > 0 ? Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                    Divider(color: ColorsPalette.amMint),
                    Text("Please select new category for these items: "),
                    Form(
                      key: _formKey,
                      child:_categorySelector(state),
                    )                    
                  ],) : Container()                  
                ],) : Container(),
                SizedBox(height: 20.0,),
                showError ? Text(errorText, style: quicksandStyle(color: ColorsPalette.redPigment)) : Container(),
                state is CategoriesLoading ? loadingWidget(ColorsPalette.amMint) : Container()
              ]),
            ),
            actions: <Widget>[
            TextButton(
              child: Text('Delete', style: TextStyle(color: ColorsPalette.juicyDarkBlue)),
              onPressed: () {
                Category? newCategory;
                if(_categoryController!.text.length > 0){
                  newCategory = new Category(name: _categoryController!.text.trim());
                  if(state.categories != null){
                    newCategory = state.categories!.firstWhere((c) => c.name!.trim() == _categoryController!.text.trim(), orElse: () => newCategory!);
                  }
                }               

                context.read<CategoriesBloc>().add(DeleteCategory(widget.category, newCategory));                
                //Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Cancel', style: TextStyle(color: ColorsPalette.juicyDarkBlue),),
              onPressed: () {                
                Navigator.pop(context);
              },
            ),
          ],
          );
        },
      )
    );
  }

  Widget _categorySelector(CategoriesState state) => new TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: this._categoryController,      
      ),
      suggestionsCallback: (pattern) {
        {
          var filteredCategories = state.categories != null ? state.categories!
              .where((c) => c.name!.toLowerCase().startsWith(pattern.toLowerCase()) && c.name != widget.category.name)
              .toList() : [];
          if (filteredCategories.length > 0) {
            return filteredCategories;
          }   
          return [];    
        }       
      },     
      hideOnLoading: true,
      hideOnEmpty: true,
      itemBuilder: (context, dynamic category) {
        return ListTile(
          title: Text(category.name),
        );
      },
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      onSuggestionSelected: (dynamic suggestion) {
        this._categoryController!.text = suggestion.name;
        //FocusScope.of(context).unfocus();
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Required field';
        }
        return null;
      });

  
}