import 'dart:convert';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pizza_app/Model/Product.dart';
import 'package:pizza_app/MyColor.dart';
import 'package:pizza_app/RegistrationScreen.dart';
import 'package:pizza_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  Color appColor = HexColor("#1A73E8");

  String currentmonth;

  @override
  void initState() {
    super.initState();
  }

  List<Product> productList = [];
  int isdataloaded;
  final databaseReference = FirebaseDatabase.instance.reference();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController numbercontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Container(
            height: height,
            color: Colors.lightBlueAccent.withOpacity(0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: Image.asset('assets/pizza_login_image.jpeg'),
                ),
                Container(
                    height: height * 0.35,
                    width: width,
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Text(
                          'LOGIN WITH YOUR VALID MOBILE NUMBER',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: width * 0.05,
                            ),
                            Container(
                              height: height * 0.06,
                              width: width * 0.1,
                              child: TextField(
                                // obscureText: true,
                                //style: style,
                                decoration: InputDecoration(
                                  hintText: "+370",
                                  enabled: false,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: width * 0.02,
                            ),
                            Container(
                              height: height * 0.06,
                              width: width * 0.75,
                              child: TextField(
                                // obscureText: true,
                                //style: style,
                                controller: numbercontroller,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                ],
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        color: Colors.black.withOpacity(0.5)),
                                  ),

                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: Colors.black.withOpacity(0.5)),
                                  ),
                                  border: new OutlineInputBorder(
                                      borderSide: new BorderSide(
                                          color:
                                              Colors.black.withOpacity(0.5))),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  labelText: "Mobile number",
                                  labelStyle: TextStyle(
                                      color: Colors.black, fontSize: 15.0),
                                  //     prefixIcon: Icon(Icons.lock,color: colorblue,),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: width * 0.03,
                            ),
                            Container(
                              height: height * 0.06,
                              width: width * 0.89,
                              child: TextField(
                                obscureText: true,
                                controller: passwordcontroller,
                                //style: style,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.lock),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        color: Colors.black.withOpacity(0.5)),
                                  ),

                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: Colors.black.withOpacity(0.5)),
                                  ),
                                  border: new OutlineInputBorder(
                                      borderSide: new BorderSide(
                                          color:
                                              Colors.black.withOpacity(0.5))),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  labelText: "Password",
                                  labelStyle: TextStyle(
                                      color: Colors.black, fontSize: 15.0),
                                  //     prefixIcon: Icon(Icons.lock,color: colorblue,),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Container(
                          width: width,
                          margin: EdgeInsets.only(
                              left: width * 0.02, right: width * 0.02),
                          height: height * 0.05,
                          child: RaisedButton(
                            onPressed: () {
                              if (numbercontroller.text.isEmpty) {
                                _scaffoldKey.currentState.showSnackBar(
                                    new SnackBar(
                                        content: new Text(
                                            "Mobile number cannot be empty")));
                              } else {
                                if (passwordcontroller.text.isEmpty) {
                                  _scaffoldKey.currentState.showSnackBar(
                                      new SnackBar(
                                          content: new Text(
                                              "Password cannot be empty")));
                                } else {
                                  loginFunc();
                                }
                              }
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'LOGIN',
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.white),
                                ),
                              ],
                            ),
                            color: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                      ],
                    )),
                Container(
                    height: height * 0.15,
                    width: width,
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Text(
                          'Don\'t have an account ? ',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Container(
                          width: width,
                          margin: EdgeInsets.only(
                              left: width * 0.02, right: width * 0.02),
                          height: height * 0.05,
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RegistrationScreen()));
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'REGISTER NOW',
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.white),
                                ),
                              ],
                            ),
                            color: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ));
  }


  // this method is user for login the user using mobile number and password
  void loginFunc() {
    databaseReference
        .child("Customers")
        .child("+370" + numbercontroller.text.toString())
        .child("account")
        .once()
        .then((DataSnapshot snapshot) async {
      if (snapshot.value == null) {
        _scaffoldKey.currentState.showSnackBar(
            new SnackBar(content: new Text("Mobile number does\'nt exists")));
      } else {
        if (snapshot.value['number'].toString() !=
            "+370" + numbercontroller.text.toString()) {
          _scaffoldKey.currentState.showSnackBar(
              new SnackBar(content: new Text("Mobile number does\'nt exists")));
        } else {
          if (snapshot.value['password'].toString() !=
              passwordcontroller.text.toString()) {
            _scaffoldKey.currentState.showSnackBar(
                new SnackBar(content: new Text("Invalid password")));
          } else {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isLogged', true);
            await prefs.setString(
                'col_user_id', "+370" + numbercontroller.text.toString());
            await prefs.setString(
                'user_name', snapshot.value['name'].toString());

            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MyHomePage()));
          }
        }
      }
    });

    /* databaseReference
          .child("Customers")
          .child("+370"+numbercontroller.text.toString())
          .child("account")
          .onValue
          .listen((event) async {



            if(event.snapshot.value==null)
              {
                _scaffoldKey.currentState.showSnackBar(new SnackBar(
                    content: new Text("Mobile number does\'nt exists")));
              }
            else {
              if (event.snapshot.value['number'].toString() !=
                  "+370"+numbercontroller.text.toString()) {
                _scaffoldKey.currentState.showSnackBar(new SnackBar(
                    content: new Text("Mobile number does\'nt exists")));
              }

              else {
                if (event.snapshot.value['password'].toString() !=
                    passwordcontroller.text.toString()) {
                  _scaffoldKey.currentState.showSnackBar(
                      new SnackBar(content: new Text("Invalid password")));
                }

                else {


                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('isLogged', true);
                  await prefs.setString('col_user_id', "+370"+numbercontroller.text.toString());
                  await prefs.setString('user_name', event.snapshot.value['name'].toString());


                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => MyHomePage()));
                }
              }
            }

      });
*/
  }
}
