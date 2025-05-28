import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traces/constants/color_constants.dart';
import 'package:traces/constants/route_constants.dart';
import 'package:traces/screens/trips/model/expense.model.dart';
import 'package:traces/screens/trips/model/expense_chart.model.dart';
import 'package:traces/screens/trips/model/expense_day_model.dart';
import 'package:traces/screens/trips/model/trip.model.dart';
import 'package:traces/screens/trips/model/trip_arguments.model.dart';
import 'package:traces/screens/trips/tripdetails/bloc/tripdetails_bloc.dart';
import 'package:traces/utils/services/shared_preferencies_service.dart';
import 'package:traces/utils/style/styles.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:d_chart/d_chart.dart';
import 'package:traces/widgets/widgets.dart';

class ExpensesView extends StatefulWidget{
 
  final List<Expense>? expenses;
  final Trip trip;
  ExpensesView(this.expenses, this.trip);

  State<ExpensesView> createState() => _ExpensesStateView();

}
  
  class _ExpensesStateView extends State<ExpensesView> with TickerProviderStateMixin{
    late TabController tabController;

    final List<Tab> viewTabs = <Tab>[
      Tab(text: 'LIST'),
      Tab(text: 'CHART')   
    ];

    final SharedPreferencesService sharedPrefsService = SharedPreferencesService();
    final String viewOptionKey = "expensesViewOption";
    var viewOption; 

    @override
    void initState() {
      super.initState();
      tabController = TabController(length: viewTabs.length, vsync: this);
      tabController.addListener(handleTabSelection);
    }

    void handleTabSelection() {
      if (tabController.indexIsChanging && tabController.index != tabController.previousIndex) {
         context.read<TripDetailsBloc>().add(ExpenseTabUpdated(tabController.index, viewOptionKey));         
      }       
    }

    @override
    void dispose() {
      tabController.dispose();
      sharedPrefsService.remove(key: viewOptionKey);
      super.dispose();
    }   

  @override
  Widget build(BuildContext context) {

    List<ExpenseDay> expenseDays = [];
    List<ExpenseChartData> expenseChartParts = [];
    double total = 0.0;
    double plannedTotal = 0.0;
    //List<Map<String, dynamic>> chartData = [];
    List <OrdinalData> chartData = [];

    if(widget.expenses != null && widget.expenses!.length > 0){

      total = widget.expenses!.where((element) => 
        element.isPaid != null && (element.isPaid ?? false)
      ).fold(0, (sum, element) => sum + (element.amountDTC ?? 0));

      plannedTotal = widget.expenses!.where((element) => 
        !(element.isPaid ?? false)
      ).fold(0, (sum, element) => sum + (element.amountDTC ?? 0));
    }

    Map<String, List<Expense>> expensesListByCategory = widget.expenses!.groupListsBy((element) => element.category?.name ?? 'Other');     

      expensesListByCategory.forEach((key, group) {
        double sum = 0.0;
        group.forEach((expense) {
            if(expense.isPaid != null && expense.isPaid!){
              sum += expense.amountDTC ?? 0;             
            }        
          });
        
        sum > 0 ? expenseChartParts.add(new ExpenseChartData(
          categoryName: key, 
          amount: sum, 
          currency: widget.trip.defaultCurrency ?? group.first.currency!, 
          color: group.first.category?.color,
          icon: group.first.category?.icon,
          amountPercent: (sum / total) * 100)) : 0;
      });

        expenseChartParts.forEach((part) {
        chartData.add(new OrdinalData(domain: part.categoryName, measure: double.parse(part.amountPercent.toStringAsFixed(2)), others: part.color));
      });      

      expenseChartParts.sort((a, b) => b.amount.compareTo(a.amount));

      Map<DateTime, List<Expense>> expensesList = widget.expenses!.groupListsBy((element) => DateUtils.dateOnly(element.date!));

      expensesList.forEach((key, expenseGroup) {
        List<String> expenseListTotal = [];

        Map<String, List<Expense>> currencyGroups = expenseGroup.groupListsBy((element) => element.currency!);

        currencyGroups.forEach((key, group) {
          double sum = 0.0;      
          group.forEach((expense) {
            if(expense.isPaid != null && expense.isPaid!){
              sum += expense.amount!;
            }        
          });
          if(sum > 0) expenseListTotal.add(double.parse(sum.toStringAsFixed(2)).toString() + ' ' + key);     
        });

        expenseDays.add(new ExpenseDay(
          key,
          expenseGroup,
          expenseListTotal
        ));
          expenseDays.sort((a, b) => a.date.compareTo(b.date));
      }); 
      

    return BlocListener<TripDetailsBloc, TripDetailsState>(
      listener: (context, state){       
        if(state is TripDetailsSuccessState){
          int? tabValue = sharedPrefsService.readInt(key: viewOptionKey);
          tabController.index = tabValue ?? 0;                  
        }        
      },
      child: BlocBuilder<TripDetailsBloc, TripDetailsState>(
        builder: (context, state){
          return RefreshIndicator(
            onRefresh: () async{
              BlocProvider.of<TripDetailsBloc>(context)..add(UpdateExpenses(widget.trip.id!));
            },
            child: (widget.expenses?.length ?? 0) > 0 && state is TripDetailsSuccessState ?  Column(children: [                
                  TabBar(
                    isScrollable: true,              
                    controller: tabController,
                    indicatorColor: Theme.of(context).colorScheme.outline,
                    tabs: viewTabs
                  ),
                  tabController.index == 0 ?_expensesTable(total, plannedTotal, expenseDays, context) 
                  : _expenseChart(total, plannedTotal, expenseDays, context, chartData, expenseChartParts)
              ],
            ) : (widget.expenses?.length ?? 0) == 0 ? Container(
                    padding: new EdgeInsets.all(25.0),
                    child: Center(
                      child: Container(child: Center(child: Text("No expenses", style: quicksandStyle(fontSize: 18.0)))),
                    )
                  ) : loadingWidget(ColorsPalette.amMint),
          ); 
        }
    ));         
  }

  _expensesTable(double total, double plannedTotal, List<ExpenseDay> expenseDays, BuildContext context) => new Container(
    padding: EdgeInsets.all(10.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(padding: EdgeInsets.symmetric(horizontal: borderPadding),child:
        Card(
          shape: RoundedRectangleBorder(            
            borderRadius: BorderRadius.circular(10.0)
          ),
          color: ColorsPalette.juicyYellow,
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Column(children: [
                Text("Total spent: ", style: quicksandStyle(fontSize: 16.0, weight: FontWeight.bold, color: ColorsPalette.white)),
                Text("${double.parse(total.toStringAsFixed(2))} ${widget.trip.defaultCurrency}", 
                  style: quicksandStyle(fontSize: accentFontSize, weight: FontWeight.bold, color: ColorsPalette.white))
              ],),
              Column(children: [
                Text("Planned: ", style: quicksandStyle(fontSize: 16.0, weight: FontWeight.bold, color: ColorsPalette.white)),
                Text("${double.parse(plannedTotal.toStringAsFixed(2))} ${widget.trip.defaultCurrency}", 
                  style: quicksandStyle(fontSize: 16.0, weight: FontWeight.bold, color: ColorsPalette.white))
              ],)
            ],)
          )
        ),         
      ),
      SingleChildScrollView(child: Container(
        constraints: BoxConstraints(
          maxHeight: scrollViewHeight,
        ),
        child: ListView.builder(
            shrinkWrap: true,
            //physics: NeverScrollableScrollPhysics(),
            itemCount: expenseDays.length,              
            itemBuilder: (context, position){
              final expenseDay = expenseDays[position];
              return _expenseDay(expenseDay, context);                  
            }
          )
      )        
      )
      ], ),
  );

  _expenseChart(double total, double plannedTotal, List<ExpenseDay> expenseDays, BuildContext context,  List <OrdinalData> chartData, List<ExpenseChartData> expenseChartParts) =>new Container(
    padding: EdgeInsets.only(top: sizerHeightlg),  
    child: Column(children: [
      Padding(
        padding: EdgeInsets.all(16),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: DChartPieO(
            data: chartData,
            configSeriesPie: ConfigSeriesPieO(),
            /*fillColor: (pieData, index) {
              return expenseChartParts.firstWhere((element) => element.categoryName == pieData["domain"]).color ?? ColorsPalette.amMint;
            },*/
            /*pieLabel: (pieData, index) {
              return "";
            },*/
            /*labelPosition: PieLabelPosition.inside,   */
          ),
        ),
      ),
      Container(width: formWidth70, padding: EdgeInsets.symmetric(horizontal: borderPadding),child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("Total spent: ", style: quicksandStyle(fontSize: 16.0, weight: FontWeight.bold)),
          Text("${double.parse(total.toStringAsFixed(2))} ${widget.trip.defaultCurrency}", style: quicksandStyle(fontSize: 16.0, weight: FontWeight.bold))
        ],),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("Planned expenses: ", style: quicksandStyle(fontSize: 16.0)),
          Text("${double.parse(plannedTotal.toStringAsFixed(2))} ${widget.trip.defaultCurrency}", style: quicksandStyle(fontSize: 16.0))
        ],)
      ],)
        ) , 
      SingleChildScrollView(child: Container(
        width: formWidth70,
        constraints: BoxConstraints(
          maxHeight: scrollViewHeightSm,
        ),
        child:  ListView.builder(
          shrinkWrap: true,
          //physics: NeverScrollableScrollPhysics(),
          itemCount: expenseChartParts.length,
          itemBuilder: (context, position){
            final chartPart = expenseChartParts[position];                    
            return  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Icon(chartPart.icon ?? Icons.category, color: chartPart.color ?? ColorsPalette.amMint),
                SizedBox(width: sizerWidthsm),
                Text(chartPart.categoryName),
              ],),
              Row(children: [                
                Text("${double.parse(chartPart.amount.toStringAsFixed(2))} ${widget.trip.defaultCurrency} | ${double.parse(chartPart.amountPercent.toStringAsFixed(2))}%")
              ],),
              //Text("\$${double.parse(chartPart.amount.toStringAsFixed(2))} | ${double.parse(chartPart.amountPercent.toStringAsFixed(2))}%")
            ],);})
      )        
      )
      ] )
  );

  _expenseDay(ExpenseDay expenseDay, BuildContext context) {
    List<Expense> expenses =  expenseDay.expenses;
    expenses.sort((a, b) => a.date!.compareTo(b.date!));

    return new Container(
      child: Card(
        elevation: 0.0,        
        child: Container(padding: EdgeInsets.all(10.0),child: Column(children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(children: [
            Text('${DateFormat.yMMMd().format(expenseDay.date)}', style: quicksandStyle(fontSize: 16.0, weight: FontWeight.bold))
          ],),          
        ],),
         SizedBox(height: 5.0),
        //Divider(color: ColorsPalette.juicyGreen),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: expenses.length,   
          itemBuilder: (context, idx){
            final expense = expenses[idx];
            return Column(            
              children: [     
                InkWell(
                  onTap: (){
                    ExpenseViewArguments args = new ExpenseViewArguments(expenseId: expense.id!, trip: widget.trip);

                    Navigator.of(context).pushNamed(expenseViewRoute, arguments: args).then((value) => {
                      BlocProvider.of<TripDetailsBloc>(context)..add(UpdateExpenses(widget.trip.id!))
                    });
                  },                  
                  child: Column(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('${DateFormat.Hm().format(expense.date!)}', style: quicksandStyle(fontSize: 15.0, weight: FontWeight.bold)),
                      SizedBox(width: 10.0),  
                      Row(children: [
                        expense.amountDTC != null ? Text('${expense.amountDTC?.toStringAsFixed(2)} ${widget.trip.defaultCurrency}', style: quicksandStyle(fontSize: 15.0, 
                        color: expense.isPaid ?? false ? ColorsPalette.black : ColorsPalette.juicyOrangeLight)) : SizedBox(height: 0),
                        expense.currency != widget.trip.defaultCurrency ? 
                          Text('(${expense.amount?.toStringAsFixed(2)} ${expense.currency})', style: quicksandStyle(fontSize: 15.0, 
                            color: expense.isPaid ?? false ? ColorsPalette.black : ColorsPalette.juicyOrangeLight)) 
                          : SizedBox(height: 0)
                      ],)                       
                     
                    ],),                   
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Column(children: [
                        Row(children: [
                          Icon(expense.category?.icon ?? Icons.category, color: expense.category?.color ?? ColorsPalette.black),
                          SizedBox(width: 4.0)                        
                        ],)                                            
                      ],),                    
                      Expanded(child: Text(
                        '${(expense.description != null && expense.description!.length > 0) ? expense.description : expense.category?.name}', 
                        style: quicksandStyle(fontSize: 15.0)))
                    ],),
                    //SizedBox(height: 5.0)
                  ],)
                )
              ],
            );
          }
        )
      ])))
  );}

}
