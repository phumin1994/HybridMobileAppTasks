import 'dart:convert';
import 'dart:math';
import 'package:badges/badges.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pizza_app/CartScreen.dart';
import 'package:pizza_app/Model/Product.dart';
import 'package:pizza_app/MyColor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryProducts extends StatefulWidget {
  String categoryid, categoryname;

  CategoryProducts({this.categoryid, this.categoryname});

  @override
  _DbrHistory createState() => _DbrHistory();
}

class _DbrHistory extends State<CategoryProducts> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  Color appColor = HexColor("#1A73E8");

  String currentmonth;

  @override
  void initState() {
    super.initState();
    loadProducts();
    loadCartCount();
  }

  Future<void> addtocartFunc(String product_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_id = prefs.getString('col_user_id') ?? '0';

    databaseReference
        .child("Customers")
        .child(user_id)
        .child("cart")
        .child(product_id)
        .once()
        .then((DataSnapshot snapshot) {
      print(snapshot.value);
      print("line603");

      if (snapshot.value != null) {
        int quantity = int.parse(snapshot.value['quantity']) + 1;
        databaseReference
            .child("Customers")
            .child(user_id)
            .child("cart")
            .child(product_id)
            .set(<String, String>{
          "productid": "" + product_id,
          "quantity": "" + quantity.toString(),
        }).then((_) async {
          _scaffoldKey.currentState
              .showSnackBar(new SnackBar(content: new Text("Cart updated")));
        });
      } else {
        databaseReference
            .child("Customers")
            .child(user_id)
            .child("cart")
            .child(product_id)
            .set(<String, String>{
          "productid": "" + product_id,
          "quantity": "1",
        }).then((_) async {
          _scaffoldKey.currentState
              .showSnackBar(new SnackBar(content: new Text("Added to cart")));
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

    if (productList.isNotEmpty) {
      productList.clear();
    }
    databaseReference.child("Products").once().then((DataSnapshot snapshot) {
      List result = snapshot.value;
      int _i = 1;

      print(result);
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

            if(widget.categoryid.toString()==value["category_id"].toString())
              {
                productList.add(product);

              }

          });


          _i += 1;
        }
      });

      setState(() {
        isdataloaded = 1;
      });
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int cartcount = 0;

  loadCartCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_id = prefs.getString('col_user_id') ?? '0';
    databaseReference
        .child("Customers")
        .child(user_id)
        .child("cart")
        .onValue
        .listen((event) {

      if (event.snapshot.value != null) {

        if (event.snapshot.value.toString().contains("null") && event.snapshot.value.toString().contains("quantity")) {



          if (event.snapshot.value != null) {
            List result = event.snapshot.value;

            print(result);

            int i = 0;
            int quantity = 0;
            setState(() {
              cartcount=0;
            });

            for (i; i < result.length; i++) {
              if (result[i] != null) {

                setState(() {
                  cartcount++;
                });
              }
            }
          } else {}

        }
        else {
          setState(() {
            cartcount=0;
          });
          Map<dynamic, dynamic> values = event.snapshot.value;
          values.forEach((key, values) {
            int quantity = 0;
            if (values != null) {
              setState(() {
                cartcount++;
              });
            }
          });


        }
      } else {}
    });
  }

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
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartScreen()));
              },
              child: Padding(
                padding:
                    EdgeInsets.only(right: width * 0.05, top: height * 0.007),
                child: Badge(
                  badgeContent: Text(cartcount.toString()),
                  child: Icon(Icons.shopping_cart),
                ),
              ),
            ),
          ],
          title: new Text(widget.categoryname),
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
                        child: productList.isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                            Container(
                                                height: height * 0.20,
                                                width: width,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                      productList[index].image,
                                                    ),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                                padding: EdgeInsets.all(8.0),
                                                child: null),
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
                                                    productList[index].name ??
                                                        '',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 15.0,
                                                        color: Colors.black),
                                                  ),
                                                  Text(
                                                    "€" +
                                                            productList[index]
                                                                .price ??
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
                                                productList[index]
                                                        .description ??
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
                                                  bottom: height * 0.01,
                                                  left: width * 0.02,
                                                  right: width * 0.02),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    productList[index]
                                                                .veg_non_veg !=
                                                            "1"
                                                        ? 'VEG PIZZA'
                                                        : 'NON-VEG PIZZA',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 15.0,
                                                        color: Colors.black),
                                                  ),
                                                  Container(
                                                    width: width * 0.25,
                                                    height: height * 0.035,
                                                    child: RaisedButton(
                                                      onPressed: () {
                                                        addtocartFunc(
                                                            productList[index]
                                                                .productid
                                                                .toString());
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
                                                            'ADD TO CART',
                                                            style: TextStyle(
                                                                fontSize: 10.0,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ],
                                                      ),
                                                      color: Colors.green,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: width * 0.03,
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
