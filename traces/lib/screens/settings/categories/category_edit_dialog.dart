import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/constants/color_constants.dart';
import 'package:traces/screens/settings/categories/bloc/categories_bloc.dart';
import 'package:traces/screens/settings/model/category.model.dart';
import 'package:traces/utils/style/styles.dart';
import 'package:traces/widgets/widgets.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class CategoryEditDialog extends StatefulWidget {

  //final Trip? trip;
  final StringCallback? callback;

  const CategoryEditDialog({Key? key, this.callback}) : super(key: key);

   @override
  _CategoryEditDialogState createState() => new _CategoryEditDialogState();
}

class _CategoryEditDialogState extends State<CategoryEditDialog>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  IconData? selectedIcon;
  Color? selectedColor;
  TextEditingController? _nameController;

  late String errorText;
  bool showError = false;

  double elementSize = 30.0; 

  /*List<Color> colors = <Color> [
    ColorsPalette.algalFuel,
    ColorsPalette.juicyYellow,
    ColorsPalette.amMint,
    ColorsPalette.juicyGreen,
    ColorsPalette.juicyOrange,
    ColorsPalette.boyzone,
    ColorsPalette.carminePink,
    ColorsPalette.christmasRed,
    ColorsPalette.frTomato
    ]; */

    List<Color> colors = new List<Color>.from(Colors.primaries);


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

  _pickIcon() async {
    IconData? icon = await showIconPicker(context,
        iconPackModes: [IconPack.material]);

      if(icon != null){
        context.read<CategoriesBloc>()..add(IconUpdated(icon)); 
      }
      print(icon?.codePoint);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoriesBloc, CategoriesState>(
      listener: (context, state) {
        if(state is CategoriesEdit){
          showError = false;
          selectedIcon = state.selectedIcon ?? state.category?.icon;
          selectedColor = state.selectedColor ?? state.category?.color;         

          if(_nameController!.text.length == 0 && state.category?.name != null) _nameController!.text = state.category!.name!;

          elementSize = MediaQuery.of(context).size.width * 0.0765;          
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
          print(fullWidth);
          print(fullheight);
          return AlertDialog(
            insetPadding: EdgeInsets.all(viewPadding),
            title: Text("Category"),
            content: SizedBox(
              width: fullWidth,
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
                child: Text('Done', style: TextStyle(color: ColorsPalette.juicyDarkBlue)),
                onPressed: () {
                  var isFormValid = _formKey.currentState!.validate();

                  if(isFormValid){
                    var newCategory = new Category(
                      name: _nameController!.text.trim(),
                      icon: selectedIcon,
                      color: selectedColor
                    );

                    if(state.selectedCategory != null){
                      newCategory = newCategory.copyWith(
                        id: state.selectedCategory!.id
                      );
                    }
                    context.read<CategoriesBloc>()..add(CategoryUpdated(newCategory));
                  }

                },
              ),
              TextButton(
                child: Text('Cancel', style: TextStyle(color: ColorsPalette.juicyDarkBlue),),
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
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start , children: [
          Text('Icon', style: quicksandStyle(fontSize: fontSize, weight: FontWeight.bold)),
          SizedBox(height: sizerHeightsm),
          SizedBox(width:  iconSize, child: InkWell(
            child: selectedIcon != null ? Icon(selectedIcon!, color: selectedColor ?? Colors.black, size: elementSize) 
              : Icon(Icons.category, color: selectedColor ?? Colors.black, size: elementSize),
            onTap: _pickIcon,
          ))          
        ],),
        Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, 
          children: [
            Text('Name', style: quicksandStyle(fontSize: fontSize, weight: FontWeight.bold)),
            SizedBox(width:  formWidth60, child: 
            TextFormField(
              decoration: InputDecoration(
                isDense: true,                      
                hintText: "e.g., Tickets"                      
              ),
              style:  quicksandStyle(fontSize: fontSize),
              controller: _nameController,
              keyboardType: TextInputType.text,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {                        
                return value!.isEmpty ? 'Required field' : null;
              }
            ))
          ],
        )
      ],),
      SizedBox(height: sizerHeightlg),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children:
            colors.map((c) => _colorOption(c, selectedColor)).toList(),           
        )),
        SizedBox(height: sizerHeightlg),
        showError ? Text(errorText, style: quicksandStyle(color: ColorsPalette.redPigment)) : SizedBox(height:0),
        state is CategoriesLoading ? loadingWidget(ColorsPalette.amMint) : SizedBox(height:0)
    ],
  );

  Widget _colorOption(Color c, Color? selectedColor) => new InkWell(
    onTap: (() {
      context.read<CategoriesBloc>()..add(ColorUpdated(c));
    }),
    child: Padding(
      padding: EdgeInsets.all(elementSize * 0.1),
      child: AnimatedContainer(
        width: elementSize,
        height: elementSize,
        duration: Duration(milliseconds: 100),
        decoration: BoxDecoration(
          color: c,
          shape: BoxShape.circle,
          border: Border.all(
            width: c == selectedColor ? 4 : 2,
            color: Colors.white,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: elementSize * 0.1,
              color: Colors.black12,
            ),
          ],
        ),
      ),
    )
);

}