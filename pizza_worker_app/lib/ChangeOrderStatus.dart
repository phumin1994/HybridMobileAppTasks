import 'dart:convert';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pizza_app/Model/Product.dart';
import 'package:pizza_app/MyColor.dart';
import 'package:pizza_app/MyOrders.dart';
import 'package:pizza_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeOrderStatus extends StatefulWidget {
  String orderid;

  ChangeOrderStatus({this.orderid});

  @override
  _ChangeOrderStatus createState() => _ChangeOrderStatus();
}

class _ChangeOrderStatus extends State<ChangeOrderStatus> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  Color appColor = HexColor("#1A73E8");

  String currentmonth;
  List<String> quantitylist = [];

  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController addresscontroller = new TextEditingController();

  int isdataloading;

  String txtorderstatus;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: new AppBar(
          backgroundColor: appColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: new Text('Order Details'),
        ),
        body: Container(
          height: height,
          color: Colors.lightBlueAccent.withOpacity(0.1),
          child: isdataloading == 0
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/pizza_loader.gif',
                          width: 150,
                          height: 150,
                        ),
                      ],
                    )
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(10.0),
                      height: height * 0.05,
                      child: RaisedButton(
                        onPressed: () {
                          setState(() {
                            txtorderstatus = "Order Confirmed";
                          });
                          updateOrderStatus(widget.orderid.toString(), context);
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Confirm Order',
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
                    Container(
                      margin: EdgeInsets.all(10.0),
                      height: height * 0.05,
                      child: RaisedButton(
                        onPressed: () {
                          setState(() {
                            txtorderstatus = "Pizza is being prepared";
                          });
                          updateOrderStatus(widget.orderid.toString(), context);
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Preparing Pizza',
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
                    Container(
                      margin: EdgeInsets.all(10.0),
                      height: height * 0.05,
                      child: RaisedButton(
                        onPressed: () {
                          setState(() {
                            txtorderstatus = "Pizza on the way";
                          });
                          updateOrderStatus(widget.orderid.toString(), context);
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Pizza on the way',
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
                    Container(
                      margin: EdgeInsets.all(10.0),
                      height: height * 0.05,
                      child: RaisedButton(
                        onPressed: () {
                          setState(() {
                            txtorderstatus = "Pizza Delivered";
                          });
                          updateOrderStatus(widget.orderid.toString(), context);
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Pizza Delivered',
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
                ),
        ));
  }

  final databaseReference = FirebaseDatabase.instance.reference();
  Future<void> updateOrderStatus(
      String order_id, BuildContext buildContext) async {
    setState(() {
      isdataloading = 0;
    });
    databaseReference
        .child("Orders")
        .child(order_id)
        .child("orderstatus")
        .set(txtorderstatus)
        .then((_) async {
      _scaffoldKey.currentState.showSnackBar(
          new SnackBar(content: new Text("Order Status Updated")));
      setState(() {
        isdataloading = 1;
      });
      Navigator.pop(buildContext);
    });
  }
}
