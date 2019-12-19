

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:share/share.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InsydLyf',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'InsydLyf'),
      debugShowCheckedModeBanner:false,
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
  String advice = 'Welcome to Lyf';
  final color1=const Color(0xFFE1094E);
  Size deviceSize;
  String _timeString;

  @override
  void initState() {
    super.initState();
    _timeString = "${DateTime.now().hour} : ${DateTime.now().minute} :${DateTime.now().second}";
    Timer.periodic(Duration(seconds:1), (Timer t)=>_getCurrentTime());
    _getAdvice();

  }

  void _getCurrentTime()  {
    setState(() {
      _timeString = "${DateTime.now().hour} : ${DateTime.now().minute} :${DateTime.now().second}";
    });
  }
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
        return CupertinoAlertDialog(
          title: new Text("InsydLyf",
              style: TextStyle(color: color1,fontSize: 18.0)),
          content: Container(
            margin: EdgeInsets.only(top:10.0),
          child:Column(
//            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Developer: C-Spydo\n\n"
                      "Email: csamsonok@gmail.com\n\n"
                      "Website: cspydo.com.ng",
                  style: TextStyle(fontSize: 15.0),
                textAlign: TextAlign.left,
              ),
            ],
          ),),

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
    deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color1,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
//            Image.asset(
//              'assets/images/logo2.png',
//              height: 40.0,
//              width: 220.0,
//            ),
            Text("InsydLyf",
                style:  TextStyle(
                    fontSize: 37.0,
                    letterSpacing: 1,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                ),


            GestureDetector(
              onTap: _showDialog,
              child: Icon(Icons.info,size: 28.0,),
            ),
          ],
        ),
      ),
      body:  Container(
          padding: EdgeInsets.only(left: 25.0, right: 12.0),
        height: deviceSize.height,
        width: deviceSize.width,
          child: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top:5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(DateFormat('dd-MM-yyyy').format(DateTime.now())+"\n"
                      +_timeString,
                      style: TextStyle(
                          fontSize: 14.0,
                          color: color1,
                      ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),),

              Container(
                  margin: EdgeInsets.only(right:13.0,top:deviceSize.width*0.59),

                  child:Column(

                  children: <Widget>[
                    Text("The Word",
                        style: TextStyle(
                            fontSize: 22.0,
                            color: color1,
                            fontWeight: FontWeight.bold)),

                    SizedBox(height: 20.0,),
                    Container(color:color1, height: 1.0, width: deviceSize.width-10, margin: EdgeInsets.only(bottom: 15.0),),
                    Container(width:deviceSize.width-85,
                        child:Text("\" " + advice + " \"", style: TextStyle(
                          fontSize: 22.0, color: color1, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic,),
                          textAlign: TextAlign.center,)),
                    Container(color:color1, height: 1.0, width: deviceSize.width-120.0, margin: EdgeInsets.only(top: 15.0),),
                    Container(
                      height: 45,
                      width: 120.0,
                      margin: EdgeInsets.only(top:10.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: RaisedButton(
                          splashColor: Colors.redAccent,
                          onPressed: () {
                            _getAdvice();
                          },
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),side: BorderSide(color: Colors.redAccent)),
                          child: Text("Another One", style: TextStyle(color: Colors.white)),
                          color: color1,
                        ),
                      ),
                    ),
                  ],
                )
              )

            ],
          ),
        ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: color1,
        onPressed: (){
          Share.share(advice);
        },
        tooltip: 'Refresh',
        child: Icon(
          Icons.share,
          size: 30.0,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
