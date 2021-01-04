import 'dart:convert';
import 'dart:math';
import 'package:badges/badges.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pizza_app/ChangeOrderStatus.dart';
import 'package:pizza_app/Model/Orders.dart';
import 'package:pizza_app/Model/Product.dart';
import 'package:pizza_app/MyColor.dart';
import 'package:pizza_app/OrderDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrders createState() => _MyOrders();
}

class _MyOrders extends State<MyOrders> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  Color appColor = HexColor("#1A73E8");

  String currentmonth;

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  List<Orders> ordersList = [];
  int isdataloaded;
  final databaseReference = FirebaseDatabase.instance.reference();

  loadOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_id = prefs.getString('col_user_id') ?? '0';
    setState(() {
      isdataloaded = 0;
    });
    databaseReference
        .child("Orders")
        .onValue
        .listen((event) {
      if (ordersList.isNotEmpty) {
        ordersList.clear();
      }

      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> values = event.snapshot.value;
        values.forEach((key, values) {
          print(values);

          Orders order = Orders(
            key.toString(),
            values["deliveryboyid"].toString(),
            values["orderaddress"].toString(),
            values["orderamount"].toString(),
            values["orderstatus"].toString(),
            values["user_id"].toString(),
            values["customer_name"].toString(),
          );

          setState(() {
            ordersList.add(order);

          });
        });

        print(ordersList);
        setState(() {
          isdataloaded = 1;
        });

/*
        for (i; i < event.snapshot.value.length; i++) {

          if (event.snapshot.value[i] != null) {
            List result = event.snapshot.value[i].value();
            print(result);

           */ /* Product product = Product(
                snapshot.value["productid"].toString(),
                snapshot.value["image"].toString(),
                snapshot.value["veg_non_veg"].toString(),
                snapshot.value["category_id"].toString(),
                snapshot.value["price"].toString(),
                snapshot.value["name"].toString(),
                snapshot.value["description"].toString(),
                "0");

            setState(() {
              productList.add(product);
            });*/ /*
          }
        }*/
      } else {
        setState(() {
          isdataloaded = 1;
        });
      }
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery
        .of(context)
        .size
        .height;
    final width = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: new AppBar(
          backgroundColor: appColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: new Text('All Orders'),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: height,
            color: Colors.lightBlueAccent.withOpacity(0.1),
            child: isdataloaded == 0
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: height,
                  width: width,
                  child: ordersList.isEmpty
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'No Orders',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0,
                            color: Colors.black),
                      ),
                    ],
                  )
                      : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: ordersList.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 5.0,
                          child: Container(
                            //margin: const EdgeInsets.all(10.0),
                            //  padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: height * 0.005,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: height * 0.01,
                                      left: width * 0.02,
                                      right: width * 0.02),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Text(
                                        "Name: " +
                                            ordersList[index]
                                                .customer_name ??
                                            '',
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight.w400,
                                            fontSize: 15.0,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.005,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: width * 0.02,
                                      right: width * 0.02),
                                  child: Text(
                                    "Address: " +
                                        ordersList[index]
                                            .orderaddress ??
                                        '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13.0,
                                        color: Colors.grey[600]),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.005,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: width * 0.02,
                                      right: width * 0.02),
                                  child: Text(
                                    "Delivery boy: " +
                                        ordersList[index]
                                            .deliveryboyid ??
                                        '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15.0,
                                        color: Colors.black),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.005,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: width * 0.02,
                                      right: width * 0.02),
                                  child: Text(
                                    "Status: " +
                                        ordersList[index]
                                            .orderstatus ??
                                        '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15.0,
                                        color: Colors.black),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.005,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: height * 0.01,
                                      left: width * 0.02,
                                      right: width * 0.02),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Text(
                                        "Order amount: € " +
                                            ordersList[index]
                                                .orderamount ??
                                            '',
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight.w400,
                                            fontSize: 15.0,
                                            color: Colors.black),
                                      ),

                                    ],
                                  ),
                                ),

                                SizedBox(
                                  width: width * 0.03,
                                ),
                                SizedBox(
                                  height: height * 0.005,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: height * 0.01,
                                      left: width * 0.02,
                                      right: width * 0.02),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: width * 0.25,
                                        height: height * 0.035,
                                        child:  ordersList[index].orderstatus.toString().contains("Confirmed")?Text(
                                          'Pizza Delivered',
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                              color:
                                              Colors.green),
                                        ):RaisedButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ChangeOrderStatus(
                                                          orderid: ordersList[
                                                          index]
                                                              .orderid
                                                              .toString(),
                                                        )));
                                          },
                                          child: Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .center,
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            children: [
                                              Text(
                                                'Change Status',
                                                style: TextStyle(
                                                    fontSize: 10.0,
                                                    color:
                                                    Colors.white),
                                              ),
                                            ],
                                          ),
                                          color: Colors.green,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                5.0),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: width * 0.25,
                                        height: height * 0.035,
                                        child:RaisedButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        OrderDetails(
                                                          orderid: ordersList[
                                                          index]
                                                              .orderid
                                                              .toString(),
                                                        )));
                                          },
                                          child: Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .center,
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            children: [
                                              Text(
                                                'Order Details',
                                                style: TextStyle(
                                                    fontSize: 10.0,
                                                    color:
                                                    Colors.white),
                                              ),
                                            ],
                                          ),
                                          color: Colors.green,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                5.0),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
