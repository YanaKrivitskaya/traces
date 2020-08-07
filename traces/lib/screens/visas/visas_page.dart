import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traces/colorsPalette.dart';
import 'package:traces/constants.dart';
import 'package:traces/screens/visas/bloc/visa/visa_bloc.dart';
import 'package:traces/screens/visas/model/visa.dart';
import 'package:traces/screens/visas/visas_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class VisasPage extends StatefulWidget {

  VisasPage({Key key}) : super(key: key);

  @override
  _VisasPageState createState() => _VisasPageState();

}

class _VisasPageState extends State<VisasPage> with SingleTickerProviderStateMixin {

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'All'),
    Tab(text: 'Active'),
    Tab(text: 'Expired'),
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /*return BlocProvider<VisaBloc>(
      create: (context) => VisaBloc(

      ),
    );*/
    return BlocProvider.value(
      value: context.bloc<VisaBloc>()..add(GetAllVisas()),
      child: new Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text('Visas', style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.lynxWhite, fontSize: 25.0))),
            backgroundColor: ColorsPalette.mazarineBlue,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.of(context).pop(),
            ),
            bottom: TabBar(
              controller: _tabController,
              tabs: myTabs,
              indicatorColor: ColorsPalette.algalFuel,
            ),
          ),
          //body: VisasView(),
          body: BlocListener<VisaBloc, VisaState>(
            listener: (context, state){


            },
            child: BlocBuilder<VisaBloc, VisaState>(builder: (context, state){
              print(state.allVisas.length);
              if(state.isLoading){
                return Center(child: CircularProgressIndicator());
              }
              if(state.isSuccess){
                return TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    Container(
                      child: Container(child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            state.allVisas != null && state.allVisas.length > 0 ?
                            Container(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: state.allVisas.length,
                                  itemBuilder: (context, position){
                                    final visa = state.allVisas[position];
                                    return Card(
                                      child: Container(
                                        padding: EdgeInsets.all(10.0),
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                                CircleAvatar(
                                                    backgroundColor: ColorsPalette.lynxWhite,
                                                    child: Text(visa.owner.substring(0, 1), style: TextStyle(color: ColorsPalette.algalFuel, fontSize: 25.0, fontWeight: FontWeight.w300),),
                                                    radius: 30.0
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(left: 20.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(visa.countryOfIssue + ' - ' + visa.type, style: TextStyle(fontSize: 15.0, color: ColorsPalette.mazarineBlue, fontWeight: FontWeight.bold)),
                                                      Text(visa.endDate.difference(visa.startDate).inDays.toString() + ' days', style: TextStyle(fontSize: 15.0)),
                                                      Text('${DateFormat.yMMMd().format(visa.startDate)} - ${DateFormat.yMMMd().format(visa.endDate)}', style: TextStyle(fontSize: 15.0)),
                                                      Text(visa.endDate.difference(DateTime.now()).inDays > 1 ? 'Active' : 'Expired', style: TextStyle(color: ColorsPalette.algalFuel, fontSize: 15.0, fontWeight: FontWeight.bold))
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                              ),
                            ) : Container()
                          ],
                        ),
                      ),),
                    ),
                    Container(
                        padding: EdgeInsets.all(10.0),
                        child: Container(
                          child: SingleChildScrollView(
                            child: Container(
                              child: Text("Tab2"),

                            ),
                          ),
                        )
                    ),
                    Container(
                        padding: EdgeInsets.all(10.0),
                        child: Container(
                          child: SingleChildScrollView(
                            child: Container(
                              child: Text("Tab3"),

                            ),
                          ),
                        )
                    )
                  ],
                );
              }
              return Center(child: CircularProgressIndicator());
            }),
          ) ,
          /*body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            Container(
              //padding: EdgeInsets.all(10.0),
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Card(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      CircleAvatar(
                                          backgroundColor: ColorsPalette.lynxWhite,
                                          child: Text('YK', style: TextStyle(color: ColorsPalette.algalFuel, fontSize: 25.0, fontWeight: FontWeight.w300),),
                                          radius: 30.0
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 20.0),
                                        child: Column(
                                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text('Lithuania - Schengen', style: TextStyle(fontSize: 15.0, color: ColorsPalette.mazarineBlue, fontWeight: FontWeight.bold)),
                                            Text('6 months', style: TextStyle(fontSize: 15.0)),
                                            Text('Sept 24, 2017 - Dec 23, 2017', style: TextStyle(fontSize: 15.0)),
                                            Text('Active', style: TextStyle(color: ColorsPalette.algalFuel, fontSize: 15.0, fontWeight: FontWeight.bold))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                        ),
                        Card(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      CircleAvatar(
                                          backgroundColor: ColorsPalette.lynxWhite,
                                          child: Text('YK', style: TextStyle(color: ColorsPalette.algalFuel, fontSize: 25.0, fontWeight: FontWeight.w300),),
                                          radius: 30.0
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 20.0),
                                        child: Column(
                                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text('Lithuania - Schengen', style: TextStyle(fontSize: 15.0, color: ColorsPalette.mazarineBlue, fontWeight: FontWeight.bold)),
                                            Text('10 months', style: TextStyle(fontSize: 15.0)),
                                            Text('Mar 13, 2019 - Jan 21, 2020', style: TextStyle(fontSize: 15.0)),
                                            Text('Expired', style: TextStyle(color: ColorsPalette.fusionRed, fontSize: 15.0, fontWeight: FontWeight.bold))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                        ),
                        Card(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      CircleAvatar(
                                          backgroundColor: ColorsPalette.lynxWhite,
                                          child: Text('SP', style: TextStyle(color: ColorsPalette.algalFuel, fontSize: 25.0, fontWeight: FontWeight.w300),),
                                          radius: 30.0
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 20.0),
                                        child: Column(
                                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text('Lithuania - Schengen', style: TextStyle(fontSize: 15.0, color: ColorsPalette.mazarineBlue, fontWeight: FontWeight.bold)),
                                            Text('1 year', style: TextStyle(fontSize: 15.0)),
                                            Text('Mar 13, 2019 - Mar 12, 2020', style: TextStyle(fontSize: 15.0)),
                                            Text('Expired', style: TextStyle(color: ColorsPalette.fusionRed, fontSize: 15.0, fontWeight: FontWeight.bold))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                        ),
                      ],
                    ),
                  ),
                )
            ),
            Container(
                padding: EdgeInsets.all(10.0),
                child: Container(
                  child: SingleChildScrollView(
                    child: Container(
                      child: Text("Tab2"),

                    ),
                  ),
                )
            ),
            Container(
                padding: EdgeInsets.all(10.0),
                child: Container(
                  child: SingleChildScrollView(
                    child: Container(
                      child: Text("Tab3"),

                    ),
                  ),
                )
            )
          ],
        ),*/
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              Navigator.pushNamed(context, visaDetailsRoute, arguments: '');
            },
            tooltip: 'Add New Visa',
            backgroundColor: ColorsPalette.algalFuel,
            child: Icon(Icons.add, color: ColorsPalette.lynxWhite),
          )
      ),
    );
    new Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Visas', style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.lynxWhite, fontSize: 25.0))),
          backgroundColor: ColorsPalette.mazarineBlue,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: myTabs,
            indicatorColor: ColorsPalette.algalFuel,
          ),
        ),
        //body: VisasView(),
        body: BlocListener<VisaBloc, VisaState>(
          listener: (context, state){
            if(state.isSuccess){
              print(state.allVisas.length);
            }

          },
          child: BlocBuilder<VisaBloc, VisaState>(builder: (context, state){
            print(state.allVisas.length);
            if(state.isLoading){
              return Center(child: CircularProgressIndicator());
            }
            if(state.isSuccess){
              return Container(
                child: Text(state.allVisas.length.toString()),
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
        ) ,
        /*body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            Container(
              //padding: EdgeInsets.all(10.0),
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Card(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      CircleAvatar(
                                          backgroundColor: ColorsPalette.lynxWhite,
                                          child: Text('YK', style: TextStyle(color: ColorsPalette.algalFuel, fontSize: 25.0, fontWeight: FontWeight.w300),),
                                          radius: 30.0
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 20.0),
                                        child: Column(
                                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text('Lithuania - Schengen', style: TextStyle(fontSize: 15.0, color: ColorsPalette.mazarineBlue, fontWeight: FontWeight.bold)),
                                            Text('6 months', style: TextStyle(fontSize: 15.0)),
                                            Text('Sept 24, 2017 - Dec 23, 2017', style: TextStyle(fontSize: 15.0)),
                                            Text('Active', style: TextStyle(color: ColorsPalette.algalFuel, fontSize: 15.0, fontWeight: FontWeight.bold))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                        ),
                        Card(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      CircleAvatar(
                                          backgroundColor: ColorsPalette.lynxWhite,
                                          child: Text('YK', style: TextStyle(color: ColorsPalette.algalFuel, fontSize: 25.0, fontWeight: FontWeight.w300),),
                                          radius: 30.0
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 20.0),
                                        child: Column(
                                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text('Lithuania - Schengen', style: TextStyle(fontSize: 15.0, color: ColorsPalette.mazarineBlue, fontWeight: FontWeight.bold)),
                                            Text('10 months', style: TextStyle(fontSize: 15.0)),
                                            Text('Mar 13, 2019 - Jan 21, 2020', style: TextStyle(fontSize: 15.0)),
                                            Text('Expired', style: TextStyle(color: ColorsPalette.fusionRed, fontSize: 15.0, fontWeight: FontWeight.bold))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                        ),
                        Card(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      CircleAvatar(
                                          backgroundColor: ColorsPalette.lynxWhite,
                                          child: Text('SP', style: TextStyle(color: ColorsPalette.algalFuel, fontSize: 25.0, fontWeight: FontWeight.w300),),
                                          radius: 30.0
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 20.0),
                                        child: Column(
                                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text('Lithuania - Schengen', style: TextStyle(fontSize: 15.0, color: ColorsPalette.mazarineBlue, fontWeight: FontWeight.bold)),
                                            Text('1 year', style: TextStyle(fontSize: 15.0)),
                                            Text('Mar 13, 2019 - Mar 12, 2020', style: TextStyle(fontSize: 15.0)),
                                            Text('Expired', style: TextStyle(color: ColorsPalette.fusionRed, fontSize: 15.0, fontWeight: FontWeight.bold))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                        ),
                      ],
                    ),
                  ),
                )
            ),
            Container(
                padding: EdgeInsets.all(10.0),
                child: Container(
                  child: SingleChildScrollView(
                    child: Container(
                      child: Text("Tab2"),

                    ),
                  ),
                )
            ),
            Container(
                padding: EdgeInsets.all(10.0),
                child: Container(
                  child: SingleChildScrollView(
                    child: Container(
                      child: Text("Tab3"),

                    ),
                  ),
                )
            )
          ],
        ),*/
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.pushNamed(context, visaDetailsRoute, arguments: '');
          },
          tooltip: 'Add New Visa',
          backgroundColor: ColorsPalette.algalFuel,
          child: Icon(Icons.add, color: ColorsPalette.lynxWhite),
        )
    );

    /*return BlocProvider.value(
      value: context.bloc<VisaBloc>()..add(GetAllVisas()),
      child:
    );*/

    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Visas', style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.lynxWhite, fontSize: 25.0))),
          backgroundColor: ColorsPalette.mazarineBlue,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: myTabs,
            indicatorColor: ColorsPalette.algalFuel,
          ),
        ),
        //body: VisasView(),
        body: BlocListener<VisaBloc, VisaState>(
          listener: (context, state){

          },
          child: BlocBuilder<VisaBloc, VisaState>(builder: (context, state){
            return Center(child: CircularProgressIndicator());
          }),
        ) ,
        /*body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            Container(
              //padding: EdgeInsets.all(10.0),
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Card(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      CircleAvatar(
                                          backgroundColor: ColorsPalette.lynxWhite,
                                          child: Text('YK', style: TextStyle(color: ColorsPalette.algalFuel, fontSize: 25.0, fontWeight: FontWeight.w300),),
                                          radius: 30.0
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 20.0),
                                        child: Column(
                                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text('Lithuania - Schengen', style: TextStyle(fontSize: 15.0, color: ColorsPalette.mazarineBlue, fontWeight: FontWeight.bold)),
                                            Text('6 months', style: TextStyle(fontSize: 15.0)),
                                            Text('Sept 24, 2017 - Dec 23, 2017', style: TextStyle(fontSize: 15.0)),
                                            Text('Active', style: TextStyle(color: ColorsPalette.algalFuel, fontSize: 15.0, fontWeight: FontWeight.bold))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                        ),
                        Card(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      CircleAvatar(
                                          backgroundColor: ColorsPalette.lynxWhite,
                                          child: Text('YK', style: TextStyle(color: ColorsPalette.algalFuel, fontSize: 25.0, fontWeight: FontWeight.w300),),
                                          radius: 30.0
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 20.0),
                                        child: Column(
                                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text('Lithuania - Schengen', style: TextStyle(fontSize: 15.0, color: ColorsPalette.mazarineBlue, fontWeight: FontWeight.bold)),
                                            Text('10 months', style: TextStyle(fontSize: 15.0)),
                                            Text('Mar 13, 2019 - Jan 21, 2020', style: TextStyle(fontSize: 15.0)),
                                            Text('Expired', style: TextStyle(color: ColorsPalette.fusionRed, fontSize: 15.0, fontWeight: FontWeight.bold))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                        ),
                        Card(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      CircleAvatar(
                                          backgroundColor: ColorsPalette.lynxWhite,
                                          child: Text('SP', style: TextStyle(color: ColorsPalette.algalFuel, fontSize: 25.0, fontWeight: FontWeight.w300),),
                                          radius: 30.0
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 20.0),
                                        child: Column(
                                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text('Lithuania - Schengen', style: TextStyle(fontSize: 15.0, color: ColorsPalette.mazarineBlue, fontWeight: FontWeight.bold)),
                                            Text('1 year', style: TextStyle(fontSize: 15.0)),
                                            Text('Mar 13, 2019 - Mar 12, 2020', style: TextStyle(fontSize: 15.0)),
                                            Text('Expired', style: TextStyle(color: ColorsPalette.fusionRed, fontSize: 15.0, fontWeight: FontWeight.bold))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                        ),
                      ],
                    ),
                  ),
                )
            ),
            Container(
                padding: EdgeInsets.all(10.0),
                child: Container(
                  child: SingleChildScrollView(
                    child: Container(
                      child: Text("Tab2"),

                    ),
                  ),
                )
            ),
            Container(
                padding: EdgeInsets.all(10.0),
                child: Container(
                  child: SingleChildScrollView(
                    child: Container(
                      child: Text("Tab3"),

                    ),
                  ),
                )
            )
          ],
        ),*/
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.pushNamed(context, visaDetailsRoute, arguments: '');
          },
          tooltip: 'Add New Visa',
          backgroundColor: ColorsPalette.algalFuel,
          child: Icon(Icons.add, color: ColorsPalette.lynxWhite),
        )
    );
  }

}

