import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/constants/color_constants.dart';
import 'package:traces/screens/settings/categories/bloc/categories_bloc.dart';
import 'package:traces/screens/settings/categories/category_edit_dialog.dart';
import 'package:traces/screens/settings/model/category.model.dart';
import 'package:traces/utils/style/styles.dart';
import 'package:traces/widgets/widgets.dart';


class CategoriesPage extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoriesBloc, CategoriesState>(
      listener: (context, state) {
        
      },
      child: BlocBuilder<CategoriesBloc, CategoriesState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
                title: Text('Categories',
                  style: quicksandStyle(fontSize: 30.0)),
                backgroundColor: ColorsPalette.white,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: ColorsPalette.black),
                  onPressed: ()=> Navigator.pop(context)
                )
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: (){
               showDialog(                
                  barrierDismissible: false, context: context,builder: (_) =>
                  BlocProvider.value(
                      value: context.read<CategoriesBloc>()..add(NewCategoryMode()),
                      child: CategoryEditDialog(callback: (val) async {
                        if(val == 'Ok'){
                          context.read<CategoriesBloc>()..add(GetCategories());            
                        }
                      }),
                    )
                  );
              },
          tooltip: 'Add New Category',
          backgroundColor: ColorsPalette.amMint,
          label: Text("New", style: quicksandStyle(color: ColorsPalette.white),),
          icon: Icon(Icons.add, color: ColorsPalette.white),
        ),
            body: Container(padding: EdgeInsets.only(bottom: 50.0), child:
              state.categories != null ? Container(
                child: state.categories!.length > 0 ? Container(
                  child: SingleChildScrollView(child: Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: state.categories!.length,
                      itemBuilder: (context, position){
                        final Category category = state.categories![position];
                        return InkWell(
                          onTap: (){
                            showDialog(                
                              barrierDismissible: false, context: context,builder: (_) =>
                              BlocProvider.value(
                                  value: context.read<CategoriesBloc>()..add(UpdateCategoryMode(category)),
                                  child: CategoryEditDialog(callback: (val) async {
                                    if(val == 'Ok'){
                                      context.read<CategoriesBloc>()..add(GetCategories());            
                                    }
                                  }),
                                )
                              );                            
                          },
                          child: ListTile(
                          leading: category.icon != null ? Icon(category.icon!, color: category.color != null ? category.color! : ColorsPalette.juicyYellow) : Icon(Icons.category, color: category.color != null ? category.color! : ColorsPalette.juicyYellow),
                          title: Text(category.name!),
                          )
                        );
                      },
                    )
                  )),
                ) : Center(child: Text('No categories')),
              ) : loadingWidget(ColorsPalette.amMint)
            ),
          );
        },
      )
    );
  }
  

}