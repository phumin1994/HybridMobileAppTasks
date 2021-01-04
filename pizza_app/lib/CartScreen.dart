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

class CartScreen extends StatefulWidget {
  @override
  _CartScreen createState() => _CartScreen();
}

class _CartScreen extends State<CartScreen> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  Color appColor = HexColor("#1A73E8");

  String currentmonth;
  List<String> quantitylist = [];

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  int totalprice = 0;

  loadCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_id = prefs.getString('col_user_id') ?? '0';
    setState(() {
      isdataloaded = 0;
    });
    databaseReference
        .child("Customers")
        .child(user_id)
        .child("cart")
        .onValue
        .listen((event) {
      if (productList.isNotEmpty) {
        productList.clear();
      }
      if (quantitylist.isNotEmpty) {
        quantitylist.clear();
      }

      if (event.snapshot.value != null) {
        if (event.snapshot.value.toString().contains("null")) {
          if (event.snapshot.value != null) {
            List result = event.snapshot.value;

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
        } else {
          Map<dynamic, dynamic> values = event.snapshot.value;
          values.forEach((key, values) {
            print(values);

            int quantity = 0;
            if (values != null) {
              quantitylist.add(values['quantity']);
              databaseReference
                  .child("Products")
                  .child(values['productid'].toString())
                  .once()
                  .then((DataSnapshot snapshot) {
                //   print(snapshot.value);
                //     print("line52");
                if (snapshot.value != null) {
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
                }

                setState(() {
                  isdataloaded = 1;
                });
              });
            }
          });
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
          title: new Text('Items in Cart'),
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
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                deleteCartproductQuantity(
                                                                    productList[
                                                                            index]
                                                                        .productid
                                                                        .toString());
                                                              },
                                                              child: Container(
                                                                child: Icon(
                                                                    Icons
                                                                        .delete_outline,
                                                                    size: 30),
                                                              ),
                                                            ),
                                                            Text(
                                                              quantitylist[
                                                                      index] ??
                                                                  '',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize:
                                                                      15.0,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                updateCartproduct(
                                                                    productList[
                                                                            index]
                                                                        .productid);
                                                              },
                                                              child: Container(
                                                                child: Icon(
                                                                    Icons
                                                                        .add_box_sharp,
                                                                    size: 30),
                                                              ),
                                                            ),
                                                          ],
                                                        )
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
                    if (getPricce() != "0")
                      Positioned(
                        bottom: 0.0,
                        child: Container(
                          width: width,
                          height: height * 0.15,
                          color: Colors.green,
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: height * 0.05,
                                    width: width * 0.9,
                                    child: TextField(
                                      controller: addresscontroller,
                                      //style: style,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.location_on,
                                          color: Colors.white,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),

                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.white),
                                        ),
                                        border: new OutlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.white)),
                                        contentPadding: EdgeInsets.fromLTRB(
                                            20.0, 15.0, 20.0, 15.0),
                                        labelText: "Enter address",
                                        labelStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.0),
                                        //     prefixIcon: Icon(Icons.lock,color: colorblue,),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: height * 0.015,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Order Total: € " + getPricce(),
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.white),
                                  ),
                                  isdataloading == 0
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'assets/pizza_loader.gif',
                                                  width: 30,
                                                  height: 30,
                                                ),
                                              ],
                                            )
                                          ],
                                        )
                                      : Container(
                                          width: width * 0.36,
                                          height: height * 0.05,
                                          child: RaisedButton(
                                            onPressed: () {
                                              if (addresscontroller
                                                  .text.isEmpty) {
                                                _scaffoldKey.currentState
                                                    .showSnackBar(new SnackBar(
                                                        content: new Text(
                                                            "Address cannot be empty")));
                                              } else {
                                                placeOrder();
                                              }
                                            },
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Place Order",
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                            color: appColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
        ));
  }

  String getPricce() {
    totalprice = 0;

    int k;
    for (k = 0; k < productList.length; k++) {
      print(productList[k].price);
      setState(() {
        totalprice =
            ((int.parse(productList[k].price) * int.parse(quantitylist[k])) +
                totalprice);
      });
    }
    print("line90");

    print(totalprice.toString());
    return totalprice.toString();
  }

  int isdataloading;

  Future<void> placeOrder() async {
    setState(() {
      isdataloading = 0;
    });
    var randomid = new Random();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_id = prefs.getString('col_user_id') ?? '0';
    String user_name = prefs.getString('user_name') ?? '0';

    print(user_name);
    print("line544");

    String finalorderid = user_id + randomid.nextInt(100).toString();
    databaseReference.child("Orders").child(finalorderid).set(<String, String>{
      "user_id": "" + user_id,
      "customer_name": "" + user_name,
      "orderamount": getPricce(),
      "orderaddress": addresscontroller.text.toString(),
      "orderstatus": "Awaiting confirmation",
      "deliveryboyid": "0",
    }).then((_) async {
      _scaffoldKey.currentState
          .showSnackBar(new SnackBar(content: new Text("Placing your order")));

      int i = 0;
      for (i; i < productList.length; i++) {
        databaseReference
            .child("Orders_Details")
            .child(finalorderid)
            .child(productList[i].productid)
            .set(<String, String>{
          "productid": "" + productList[i].productid,
          "quantity": quantitylist[i].toString(),
        }).then((_) async {
          databaseReference
              .child("Customers")
              .child(user_id)
              .child("cart")
              .remove()
              .then((_) async {
            _scaffoldKey.currentState.showSnackBar(
                new SnackBar(content: new Text("Order Successfully placed")));

            setState(() {
              isdataloading = 1;
            });
            //  Navigator.pop(context);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MyHomePage()));
          });
        });
      }
    });
  }

  Future<void> updateCartproduct(String product_id) async {
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
          "quantity": quantity.toString(),
        }).then((_) async {
          _scaffoldKey.currentState.showSnackBar(
              new SnackBar(content: new Text("Items in Cart updated")));
        });
      } else {}
    });
  }

  Future<void> deleteCartproductQuantity(String product_id) async {
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
        int quantity = int.parse(snapshot.value['quantity']) - 1;
        if (snapshot.value['quantity'] == "1") {
          databaseReference
              .child("Customers")
              .child(user_id)
              .child("cart")
              .child(product_id)
              .remove()
              .then((_) async {
            _scaffoldKey.currentState.showSnackBar(
                new SnackBar(content: new Text("Items in Cart updated")));
          });
        } else {
          databaseReference
              .child("Customers")
              .child(user_id)
              .child("cart")
              .child(product_id)
              .set(<String, String>{
            "productid": "" + product_id,
            "quantity": quantity.toString(),
          }).then((_) async {
            _scaffoldKey.currentState.showSnackBar(
                new SnackBar(content: new Text("Items in Cart updated")));
          });
        }
      } else {}
    });
  }
}
