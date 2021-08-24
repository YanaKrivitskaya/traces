import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../constants/color_constants.dart';
import '../../../../utils/style/styles.dart';
import '../../../../widgets/widgets.dart';
import '../../model/expense.model.dart';
import '../../model/trip.model.dart';
import '../../model/trip_settings.model.dart';
import 'bloc/expensecreate_bloc.dart';

class ExpenseCreateView extends StatefulWidget{
  final Trip trip;  

  ExpenseCreateView({required this.trip});

  @override
  _ExpenseCreateViewViewState createState() => _ExpenseCreateViewViewState();
}


class _ExpenseCreateViewViewState extends State<ExpenseCreateView>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Expense? newExpense;

  TextEditingController? _nameController;
  TextEditingController? _amountController;
  TextEditingController? _categoryController;
  TextEditingController? _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = new TextEditingController();
    _amountController = new TextEditingController();    
    _categoryController = new TextEditingController();    
    _descriptionController = new TextEditingController();
 
  }

  @override
  void dispose() {
    _nameController!.dispose();  
    _amountController!.dispose();
    _categoryController!.dispose();   
    _descriptionController!.dispose();   
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExpenseCreateBloc, ExpenseCreateState>(
      listener: (context, state) {
        if(state is ExpenseCreateEdit && state.loading){
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              backgroundColor: ColorsPalette.juicyOrange,
              content: Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [SizedBox(
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            ColorsPalette.lynxWhite),
                      ),
                      height: 30.0,
                      width: 30.0,
                    ),
                ],
                ),
            ));
          }
          if(state is ExpenseCreateSuccess){
            ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              backgroundColor: ColorsPalette.juicyOrange,
              content: Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [ 
                    Icon(Icons.check, color: ColorsPalette.lynxWhite,)
                ],
                ),
              ));
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.pop(context);
              });
          }
          if(state is ExpenseCreateError){
            ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              backgroundColor: ColorsPalette.redPigment,
              content: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Container(width: 250,
                  child: Text(
                    state.error,
                    style: quicksandStyle(color: ColorsPalette.lynxWhite),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,
                  ),
                ),
                Icon(Icons.error, color: ColorsPalette.lynxWhite)
                ],
                ),
              ));
          }
      },
      child: BlocBuilder<ExpenseCreateBloc, ExpenseCreateState>(
        builder: (context, state){
          return Scaffold(
            appBar: AppBar(
                centerTitle: true,
                title: Text('Create expense',
                  style: quicksandStyle(fontSize: 30.0)),
                backgroundColor: ColorsPalette.white,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.close_rounded),
                  onPressed: ()=> Navigator.pop(context)
                ),
                actions: [
                  IconButton(
                    onPressed: (){
                      FocusScope.of(context).unfocus();
                      var isFormValid = _formKey.currentState!.validate();                 

                      if(isFormValid){
                        newExpense = state.expense!.copyWith(
                          name: _nameController!.text.trim(),                        
                          description: _descriptionController!.text.trim(),
                          amount: double.parse(_amountController!.text.trim()),
                          currency: state.expense!.currency ?? TripSettings.currency.first,                        
                          category: _categoryController!.text.trim(),
                          isPaid: state.expense!.isPaid ?? true
                        );                                    
                        context.read<ExpenseCreateBloc>().add(ExpenseSubmitted(newExpense, widget.trip.id!));
                    }},
                    icon: Icon(Icons.check, color: ColorsPalette.juicyOrange))
                ],
            ),
            body: state.expense != null ? Container(
              padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0, bottom: 40.0),
              child:SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: _expenseDetailsForm(state),
                  ),
                )
            ) : loadingWidget(ColorsPalette.juicyOrange),
          );
        },
      ),
    );
  }

  Widget _expenseDetailsForm(ExpenseCreateState state) => 
    new Column(crossAxisAlignment:  CrossAxisAlignment.start, children: [
      Text('Name', style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)), 
      TextFormField(
        decoration: InputDecoration(
          isDense: true,                      
          hintText: "e.g., Tea in Lisboa"                      
        ),
        style:  quicksandStyle(fontSize: 18.0),
        controller: _nameController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {                        
          return value!.isEmpty ? 'Required field' : null;
        },
      ),
      SizedBox(height: 20.0),
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Icon(Icons.date_range),
        SizedBox(width: 20.0),
        InkWell(
          child: state.expense!.date != null 
            ? Text('${DateFormat.yMMMd().format( state.expense!.date!)}', style: quicksandStyle(fontSize: 18.0)) 
            : Text('Date', style: quicksandStyle(fontSize: 18.0)),
          onTap: () => _selectDate(context, state, widget.trip)
        )],),
      SizedBox(height: 20.0,),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [          
          Text('Amount', style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)), 
          SizedBox(height: 10.0),
          SizedBox(width:  MediaQuery.of(context).size.width * 0.40,
            child: TextFormField(
              decoration: InputDecoration(
                isDense: true,                      
                hintText: "e.g., 10.25"                      
              ),
              style:  quicksandStyle(fontSize: 18.0),
              controller: _amountController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {                        
                return value!.isEmpty ? 'Required field' : null;
              }
            )
          )
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Currency', style: quicksandStyle(fontSize: 18.0, weight: FontWeight.bold)), 
          SizedBox(width:  MediaQuery.of(context).size.width * 0.40,
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
        value: state.expense!.currency ?? TripSettings.currency.first,
        isExpanded: true,        
        items:
          TripSettings.currency.map((String value) {
          return new DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [                  
                  new Text(value),
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
      firstDate: trip.startDate ?? DateTime(2015),
      lastDate: trip.endDate ?? DateTime(2101),        
    );
    if (picked != null) {
      context.read<ExpenseCreateBloc>().add(DateUpdated(picked));      
    }
  }

}