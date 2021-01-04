import 'dart:convert';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pizza_app/Model/Product.dart';
import 'package:pizza_app/MyColor.dart';
import 'package:pizza_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetails extends StatefulWidget {
  String orderid;

  OrderDetails({this.orderid});

  @override
  _OrderDetails createState() => _OrderDetails();
}

class _OrderDetails extends State<OrderDetails> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  Color appColor = HexColor("#1A73E8");

  String currentmonth;
  List<String> quantitylist = [];

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  loadCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_id = prefs.getString('col_user_id') ?? '0';
    setState(() {
      isdataloaded = 0;
    });
    databaseReference
        .child("Orders_Details")
        .child(widget.orderid.toString())
        .onValue
        .listen((event) {
      if (productList.isNotEmpty) {
        productList.clear();
      }
      if (event.snapshot.value != null) {
        List result = event.snapshot.value;
        print("line51");

        print(result);

        int i = 0;

        int quantity = 0;
        for (i; i < result.length; i++) {
          if (result[i] != null) {
            quantitylist.add(result[i]['quantity']);
            databaseReference
                .child("Products")
                .child(result[i]['productid'].toString())
                .once()
                .then((DataSnapshot snapshot) {
              //   print(snapshot.value);
              //     print("line52");
              if (snapshot.value != null) {
                print("here" + i.toString());

                Product product = Product(
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
                });
                quantity = 0;
                //print(productList[0]);
              }

              setState(() {
                isdataloaded = 1;
              });
            });
          }
        }
      } else {
        setState(() {
          isdataloaded = 1;
        });
      }
    });
  }

  List<Product> productList = [];
  int isdataloaded;
  final databaseReference = FirebaseDatabase.instance.reference();

  loadProducts() async {
    setState(() {
      isdataloaded = 0;
    });
    databaseReference.child("Products").once().then((DataSnapshot snapshot) {
      List result = snapshot.value;
      int _i = 1;

      result.forEach((value) {
        //print(value);
        if (value != null) {
          print("here");
          Product product = Product(
              value["productid"].toString(),
              value["image"].toString(),
              value["veg_non_veg"].toString(),
              value["category_id"].toString(),
              value["price"].toString(),
              value["name"].toString(),
              value["description"].toString(),
              "0");

          setState(() {
            productList.add(product);
          });

          print(productList[0]);

          _i += 1;
        }
      });

      setState(() {
        isdataloaded = 1;
      });
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController addresscontroller = new TextEditingController();

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
              : Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            height: height,
                            width: width,
                            child: productList.isEmpty
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '',
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
                                      itemCount: productList.length,
                                      //physics: NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (context, index) {
                                        return Card(
                                          elevation: 5.0,
                                          child: Container(
                                            //margin: const EdgeInsets.all(10.0),
                                            padding: const EdgeInsets.all(5.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child: Container(
                                                      height: height * 0.10,
                                                      width: width,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                            productList[index]
                                                                .image,
                                                          ),
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                      margin:
                                                          EdgeInsets.all(10.0),
                                                      child: null),
                                                ),
                                                Expanded(
                                                  flex: 7,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          productList[index]
                                                                  .name ??
                                                              '',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 15.0,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        SizedBox(
                                                          height: height * 0.01,
                                                        ),
                                                        Text(
                                                          "€" +
                                                                  productList[
                                                                          index]
                                                                      .price ??
                                                              '',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 15.0,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        SizedBox(
                                                          height: height * 0.01,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        height: 30,
                                                        width: 30,
                                                        child: Image.asset(productList[
                                                                        index]
                                                                    .veg_non_veg !=
                                                                "1"
                                                            ? 'assets/vegicon.png'
                                                            : 'assets/nonvegicon.png'),
                                                      )
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
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ));
  }

  int isdataloading;
}
