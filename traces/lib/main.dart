import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.lightGreen,
        accentColor: Colors.amberAccent,
        textTheme: GoogleFonts.quicksandTextTheme(Theme.of(context).textTheme)
        /*buttonTheme: ButtonThemeData(
            buttonColor: Colors.lightGreen,     //  <-- dark color
            textTheme: ButtonTextTheme.normal, //  <-- this auto selects the right color
          )*/
      ),
      home: MyHomePage(title: 'Family Travel Planner'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  //int _counter = 0;

  void _incrementCounter() {
    setState(() {
      //_counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //Image.asset('assets/logo_dark_orange.png')
                  Text("Traces",style: GoogleFonts.quicksand(textStyle: TextStyle(color: Colors.orange, fontSize: 44.0)))
                ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                    children: <Widget>[
                      FlatButton(
                        onPressed: () => {},
                        padding: EdgeInsets.all(10.0),
                        child: Column( // Replace with a Row for horizontal icon + text
                          children: <Widget>[
                            Icon(Icons.card_travel, color: Colors.orange, size: 60.0),
                            Text("Trips", style: TextStyle(color: Colors.orangeAccent, fontSize: 20.0))
                          ],
                        ),
                      ),
                    ]
                ),
                Column(
                    children: <Widget>[
                      FlatButton(
                        onPressed: () => {},
                        padding: EdgeInsets.all(10.0),
                        child: Column( // Replace with a Row for horizontal icon + text
                          children: <Widget>[
                            Icon(Icons.explore, color: Colors.lightGreen, size: 60.0),
                            Text("Map", style: TextStyle(color: Colors.lightGreen, fontSize: 20.0))
                          ],
                        ),
                      ),
                    ]
                ),
                Column(
                    children: <Widget>[
                      FlatButton(
                        onPressed: () => {},
                        padding: EdgeInsets.all(10.0),
                        child: Column( // Replace with a Row for horizontal icon + text
                          children: <Widget>[
                            Icon(Icons.note, color: Colors.lightGreen, size: 60.0),
                            Text("Notes", style: TextStyle(color: Colors.lightGreen, fontSize: 20.0))
                          ],
                        ),
                      ),
                    ]
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                    children: <Widget>[
                      FlatButton(
                        onPressed: () => {},
                        padding: EdgeInsets.all(10.0),
                        child: Column( // Replace with a Row for horizontal icon + text
                          children: <Widget>[
                            Icon(Icons.flight, color: Colors.lightGreen, size: 60.0),
                            Text("Flights", style: TextStyle(color: Colors.lightGreen, fontSize: 20.0))
                          ],
                        ),
                      ),
                    ]
                ),
                Column(
                    children: <Widget>[
                      FlatButton(
                        onPressed: () => {},
                        padding: EdgeInsets.all(10.0),
                        child: Column( // Replace with a Row for horizontal icon + text
                          children: <Widget>[
                            Icon(Icons.attach_money, color: Colors.lightGreen, size: 60.0),
                            Text("Expenses", style: TextStyle(color: Colors.lightGreen, fontSize: 20.0))
                          ],
                        ),
                      ),
                    ]
                ),
                Column(
                    children: <Widget>[
                      FlatButton(
                        onPressed: () => {},
                        padding: EdgeInsets.all(10.0),
                        child: Column( // Replace with a Row for horizontal icon + text
                          children: <Widget>[
                            Icon(Icons.home, color: Colors.lightGreen, size: 60.0),
                            Text("Hotels", style: TextStyle(color: Colors.lightGreen, fontSize: 20.0))
                          ],
                        ),
                      ),
                    ]
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                    children: <Widget>[
                      FlatButton(
                        onPressed: () => {},
                        padding: EdgeInsets.all(10.0),
                        child: Column( // Replace with a Row for horizontal icon + text
                          children: <Widget>[
                            Icon(Icons.perm_identity, color: Colors.lightGreen, size: 60.0),
                            Text("Profile", style: TextStyle(color: Colors.lightGreen, fontSize: 20.0))
                          ],
                        ),
                      ),
                    ]
                ),
                Column(
                    children: <Widget>[
                      FlatButton(
                        onPressed: () => {},
                        padding: EdgeInsets.all(10.0),
                        child: Column( // Replace with a Row for horizontal icon + text
                          children: <Widget>[
                            Icon(Icons.settings, color: Colors.lightGreen, size: 60.0),
                            Text("Settings", style: TextStyle(color: Colors.lightGreen, fontSize: 20.0))
                          ],
                        ),
                      ),
                    ]
                )
              ],
            ),
          ],
        ),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),*/ // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}