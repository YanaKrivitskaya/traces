import 'package:flutter/material.dart';
import 'package:traces/constants/color_constants.dart';
import 'package:traces/screens/trips/model/expense.model.dart';
import 'package:traces/screens/settings/model/category.model.dart';
import 'package:traces/screens/trips/model/trip.model.dart';
import 'package:traces/screens/trips/model/trip_settings.model.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:traces/screens/trips/tripdetails/expenses/expense_edit/bloc/expensecreate_bloc.dart';
import 'package:traces/utils/style/styles.dart';
import 'package:traces/widgets/widgets.dart';

class CreateExpenseDialog extends StatefulWidget {

  final Trip? trip;
  final ExpenseCallback? callback;

  const CreateExpenseDialog({Key? key, this.trip, this.callback}) : super(key: key);

   @override
  _CreateExpenseDialogState createState() => new _CreateExpenseDialogState();
}

class _CreateExpenseDialogState extends State<CreateExpenseDialog>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Expense? newExpense;
  TextEditingController? _amountController;
  TextEditingController? _categoryController;
  TextEditingController? _descriptionController;

  @override
  void initState() {
    super.initState();
    _amountController = new TextEditingController();    
    _categoryController = new TextEditingController();    
    _descriptionController = new TextEditingController();
 
  }

  @override
  void dispose() {
    _amountController!.dispose();
    _categoryController!.dispose();   
    _descriptionController!.dispose();   
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<ExpenseCreateBloc, ExpenseCreateState>(
      listener: (context, state){
        if(state is ExpenseCreateEdit){
          if(_categoryController!.text.length == 0 && state.expense!.category != null) _categoryController!.text = state.expense!.category!.name!;
          if(_descriptionController!.text.length == 0) _descriptionController!.text = state.expense!.description ?? '';
          if(_amountController!.text.length == 0 && state.expense!.amount != null) _amountController!.text = state.expense!.amount.toString();
        }
      },
      child: BlocBuilder<ExpenseCreateBloc, ExpenseCreateState>(
      bloc: BlocProvider.of(context),
      builder: (context, state){
        if(state is ExpenseCreateEdit && !state.loading){
          return AlertDialog(
            insetPadding: EdgeInsets.all(30.0),
            title: Text("Expense"),
            content: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(            
                child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                  children: [  
                    Form(
                      key: _formKey,
                      child: _expenseDetailsForm(state),
                    )                  
                  ],
                )
              )
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Done', style: TextStyle(color: ColorsPalette.meditSea)),
                onPressed: () {
                  var isFormValid = _formKey.currentState!.validate();

                  var category = new Category(name: _categoryController!.text.trim());
                  if(state.categories != null){
                    category = state.categories!.firstWhere((c) => c.name! == _categoryController!.text.trim(), orElse: () => category);
                  }                  

                  if(isFormValid){
                    Expense newExpense = state.expense!.copyWith(                                               
                      description: _descriptionController!.text.trim(),
                      amount: double.parse(_amountController!.text.trim()),
                      currency: state.expense!.currency ?? TripSettings.currency.first,                        
                      category: category,
                      isPaid: state.expense!.isPaid ?? true
                    );
                    widget.callback!(newExpense);
                    Navigator.pop(context);
                  }                  
                },
              ),
              TextButton(
                child: Text('Cancel', style: TextStyle(color: ColorsPalette.meditSea),),
                onPressed: () {
                  widget.callback!(null);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
        return loadingWidget(ColorsPalette.freshYellow);
        
      }
    ),
    );    
  }

  Widget _expenseDetailsForm(ExpenseCreateState state) => 
    new Column(crossAxisAlignment:  CrossAxisAlignment.start, children: [
      Text('Category', style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)), 
      _categorySelector(state),
      SizedBox(height: sizerHeight),
       Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(
          //width:  MediaQuery.of(context).size.width * 0.45,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Icon(Icons.date_range),
            SizedBox(width: 10.0),
            InkWell(
              child: state.expense!.date != null 
                ? Text('${DateFormat.yMMMd().format( state.expense!.date!)}', style: quicksandStyle(fontSize: 18.0)) 
                : Text('Date', style: quicksandStyle(fontSize: fontSize)),
              onTap: () => _selectDate(context, state, widget.trip!)
            )
          ],),
        ),       
        Container(
          //width:  MediaQuery.of(context).size.width * 0.45,
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(width: 20.0),
            Icon(Icons.schedule),
            SizedBox(width: 10.0),
            InkWell(
              child: state.expense!.date != null 
                ? Text('${DateFormat.jm().format(state.expense!.date!)}', style: quicksandStyle(fontSize: 18.0)) 
                : Text('Time', style: quicksandStyle(fontSize: fontSize)),
              onTap: () => _selectTime(context, state, widget.trip!),
            )],),
        ) 
      ],),
      SizedBox(height: 20.0,),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [          
          Text('Amount', style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)), 
          SizedBox(height: 9.0),
          SizedBox(width:  MediaQuery.of(context).size.width * 0.30,
            child: TextFormField(
              decoration: InputDecoration(
                isDense: true,                      
                hintText: "e.g., 10.25"                      
              ),
              style:  quicksandStyle(fontSize: 18.0),
              controller: _amountController,
              keyboardType: TextInputType.number,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {                        
                return value!.isEmpty ? 'Required field' : null;
              }
            )
          )
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Currency', style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)), 
          SizedBox(width:  MediaQuery.of(context).size.width * 0.30,
            child: _currencySelector(state)
          )
        ])
      ]),
      SizedBox(height: 10.0,),
      Row(
        children: [
          SizedBox(
              height: 24.0,
              width: 24.0,
              child: Checkbox(
                value: state.expense!.isPaid ?? true,
                onChanged: (value) {
                  context.read<ExpenseCreateBloc>().add(PaidUpdated(value!));      
                },
              ),
          ),
          SizedBox(width: 15.0,),
          Text('Paid', style: quicksandStyle(fontSize: 18.0)),
        ],
      ),
      SizedBox(height: 10.0),
      Text('Description', style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)), 
      TextFormField(
        decoration: InputDecoration(
          isDense: true,                      
          hintText: "e.g., two black teas"                      
        ),
        minLines: 5,
        maxLines: 10,
        style:  quicksandStyle(fontSize: 18.0),
        controller: _descriptionController
      )
    ]);

    Widget _currencySelector(ExpenseCreateState state) =>
      new DropdownButtonFormField<String>(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: -10)
        ),
        value: state.expense!.currency ?? TripSettings.currency.first,
        isExpanded: true,        
        items:
          TripSettings.currency.map((String value) {
          return new DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  new Text(value)
                ],
              ));
        }).toList(),
        onChanged: (String? value) {
          state.expense = state.expense!.copyWith(currency: value);
          FocusScope.of(context).unfocus();
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          return value == null ? 'Required field' : null;
        },
      );

  Future<Null> _selectDate(
    BuildContext context, ExpenseCreateState state, Trip trip) async {
    FocusScope.of(context).unfocus();
    final DateTime? picked = await showDatePicker (
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(primarySwatch: ColorsPalette.matTripCalendarColor),
          child: child!,
        );
      },
      context: context,   
      initialDate: state.expense!.date ?? trip.startDate ?? DateTime.now(),      
      firstDate: DateTime(2015),
      lastDate: trip.endDate ?? DateTime(2101),        
    );
    if (picked != null) {
      context.read<ExpenseCreateBloc>().add(DateUpdated(picked));      
    }
  }

  Future<Null> _selectTime(BuildContext context, ExpenseCreateState state, Trip trip) async {
    final TimeOfDay? picked = await showTimePicker(
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(primarySwatch: ColorsPalette.matTripCalendarColor),
          child: child!,
        );
      },
      context: context,
      initialTime: TimeOfDay.fromDateTime(state.expense!.date ?? DateTime.now()),
    );
    if (picked != null) {
      if(state.expense!.date != null){      
        var date = state.expense!.date!;
        var expenseDate = new DateTime.utc(date.year, date.month, date.day, picked.hour, picked.minute);
        context.read<ExpenseCreateBloc>().add(DateUpdated(expenseDate));    
      }
      
    }
  }
  
  Widget _categorySelector(ExpenseCreateState state) => new TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: this._categoryController,      
      ),
      suggestionsCallback: (pattern) {
        {
          var filteredCategories = state.categories != null ? state.categories!
              .where((c) => c.name!.toLowerCase().startsWith(pattern.toLowerCase()))
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
        FocusScope.of(context).unfocus();
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Required field';
        }
        return null;
      });
}

  
