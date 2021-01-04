import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:pizza_app/LoginPage.dart';
import 'package:pizza_app/Model/Product.dart';
import 'package:pizza_app/MyColor.dart';
import 'package:pizza_app/MyOrders.dart';
import 'package:pizza_app/NewOrders.dart';
import 'package:pizza_app/SplashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pizza Delivery Worker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color appColor = HexColor("#1A73E8");
  static List<String> imgList = [
    'assets/image1.png',
    'assets/image2.png',
    'assets/image3.png'
  ];
  static List<String> imgListmenu = [
    'assets/pizza1.png',
    'assets/combo1.png',
    'assets/pizza3.png',
    'assets/beverages.png'
  ];
  int _current = 0;

  int cartcount = 0;

  loadCartCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_id = prefs.getString('col_user_id') ?? '0';
    databaseReference
        .child("Workers")
        .child(user_id)
        .child("cart")
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        List result = event.snapshot.value;

        print(result);

        int i = 0;
        cartcount = 0;

        for (i; i < result.length; i++) {
          if (result[i] != null) {
            cartcount++;
          }
        }
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

  @override
  void initState() {
    super.initState();
    loadCartCount();
    loadProducts();
  }

  Widget createDrawerBodyItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              // SizedBox(
              //   height: 20,
              // ),
              Container(
                  color: appColor,
                  margin: EdgeInsets.only(top: height * 0.035),
                  padding: EdgeInsets.all(width * 0.05),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_pin,
                        color: Colors.white,
                        size: 50,
                      ),
                      SizedBox(
                        width: width * 0.01,
                      ),
                      Text("WELCOME ",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500)),
                    ],
                  )),
              createDrawerBodyItem(
                  icon: Icons.home,
                  text: 'HOME',
                  onTap: () {
                    Navigator.pop(context);
                  }),
              createDrawerBodyItem(
                  icon: Icons.format_list_numbered,
                  text: 'MY ORDERS',
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyOrders()));
                  }),

              createDrawerBodyItem(
                  icon: Icons.exit_to_app,
                  text: 'LOGOUT',
                  onTap: () {
                    dologout();
                  }),
              Divider(),
              ListTile(
                title: Text('App version 1.0.0'),
                onTap: () {},
              ),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: appColor,
          title: Text('Pizza Delivery Worker'),
          leading: IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () => _scaffoldKey.currentState.openDrawer(),
          ),
        ),
        body: NewOrders());
  }

  Future<void> dologout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLogged', false);
    await prefs.setString('col_user_id', '');

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
