import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Talkie',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Talkie'),
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
  String advice = 'Thou shall be awesomely Advised\nOya, Keep Pressing Refresh';

  dynamic _getAdvice() async {
    var url = 'https://api.adviceslip.com/advice';
    try {
      final response = await http.get(url);
      var scode = response.statusCode;
      if (scode == 200) {
        Map res = json.decode(response.body.toString());
        setState(() {
          advice = res["slip"]["advice"].toString();
        });
      } else {
        showToast('Retry');
      }
    } catch (ex) {
      print("Talkr: " + ex.toString());
    }
  }

  void showToast(var mssg) {
    Fluttertoast.showToast(
      msg: mssg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
//        bgcolor: "#00bfff",
//        textcolor: '#ffffff'
    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Talkie: by C-Spydo",
              style: TextStyle(color: Colors.redAccent)),
          content: new Text(
              "Talkie advises you......& whatever\n\n"
              "Developer:C-Spydo ( cspydo.com.ng, csamsonok@gmail.com, +2348137442067"
              "\n\nBTW: You should update often, possibly weekly",
              style: TextStyle(fontSize: 13.0)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //8c52ff
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF8c52ff),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Image.asset(
              'assets/images/logo2.png',
              height: 40.0,
              width: 220.0,
            ),
            GestureDetector(
              onTap: _showDialog,
              child: Icon(Icons.info),
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.only(left: 25.0, right: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("\" " + advice + " \"",
                  style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: _getAdvice,
        tooltip: 'Refresh',
        child: Icon(
          Icons.refresh,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
