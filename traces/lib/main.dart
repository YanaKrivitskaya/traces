import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traces/colorsPalette.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Traces',
      theme: ThemeData(
        primaryColor: ColorsPalette.mainColor,
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
      appBar: AppBar(
        title: Text('Traces', style: GoogleFonts.quicksand(textStyle: TextStyle(color: ColorsPalette.grayLight, fontSize: 40.0))),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 10, color: ColorsPalette.mainColor),
            color: ColorsPalette.backColor
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              /*Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Traces",style: GoogleFonts.quicksand(textStyle: TextStyle(color: Colors.orange, fontSize: 44.0)))
                  ]
              ),*/
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _menuTile(Icons.card_travel, "Trips", ColorsPalette.beniukonBronze),
                  _menuTile(Icons.explore, "Map", ColorsPalette.beniukonBronze),
                  _menuTile(Icons.note, "Notes", ColorsPalette.beniukonBronze)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _menuTile(Icons.flight, "Flights", ColorsPalette.beniukonBronze),
                  _menuTile(Icons.attach_money, "Expenses", ColorsPalette.beniukonBronze),
                  _menuTile(Icons.home, "Hotels", ColorsPalette.beniukonBronze)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _menuTile(Icons.call_to_action, "Visas", ColorsPalette.beniukonBronze),
                  _menuTile(Icons.perm_identity, "Profile", ColorsPalette.beniukonBronze),
                  _menuTile(Icons.settings, "Settings", ColorsPalette.beniukonBronze)
                ],
              ),
            ],
          ),
        )
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),*/ // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Column _menuTile(IconData icon, String title, Color color) =>Column(
    children: <Widget>[
      FlatButton(
        onPressed: () => {},
        padding: EdgeInsets.all(10.0),
        child: Column( // Replace with a Row for horizontal icon + text
          children: <Widget>[
            /*Image(
              image: new AssetImage(iconPath),
              //color: null
            ),*/
            //Icon(icon, color: ColorsPalette.iconColor, size: 60.0),
            Icon(icon, color: color, size: 60.0),
            Text(title, style: TextStyle(color: ColorsPalette.iconTitle, fontSize: 20.0))
          ],
        ),
      ),
    ]
);