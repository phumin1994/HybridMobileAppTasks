import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pizza_app/CartScreen.dart';
import 'package:pizza_app/CategoryProducts.dart';
import 'package:pizza_app/LoginPage.dart';
import 'package:pizza_app/Model/Product.dart';
import 'package:pizza_app/MyColor.dart';
import 'package:pizza_app/MyOrders.dart';
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
      title: 'Pizza Delivery',
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
        .child("Customers")
        .child(user_id)
        .child("cart")
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        if (event.snapshot.value.toString().contains("null") &&
            event.snapshot.value.toString().contains("quantity")) {
          if (event.snapshot.value != null) {
            List result = event.snapshot.value;

            print(result);

            int i = 0;
            int quantity = 0;
            setState(() {
              cartcount = 0;
            });

            for (i; i < result.length; i++) {
              if (result[i] != null) {
                setState(() {
                  cartcount++;
                });
              }
            }
          } else {}
        } else {
          setState(() {
            cartcount = 0;
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
        title: Text('Pizza Delivery'),
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState.openDrawer(),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CartScreen()))
                  .then((value) {
                print("here");
                setState(() {
                  cartcount = 0;
                });
                loadCartCount();
              });
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
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: CarouselSlider(
              items: imgList
                  .map((item) => Container(
                        child: Container(
                          margin: EdgeInsets.all(10.0),
                          width: width * 0.9,
                          child: Stack(
                            children: [
                              Container(
                                width: width * 0.9,
                                child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                    child: Image.asset(item, fit: BoxFit.fill)),
                              ),
                              Positioned(
                                bottom: 5.0,
                                right: width * 0.1,
                                left: width * 0.1,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: imgList.map((url) {
                                    int index = imgList.indexOf(url);
                                    return Container(
                                      width: _current == index ? 9.0 : 5.0,
                                      height: _current == index ? 9.0 : 5.0,
                                      margin: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 2.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _current == index
                                            ? Colors.white
                                            : Colors.white,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
              options: CarouselOptions(
                  autoPlay: true,
                  //   enlargeCenterPage: true,
                  aspectRatio: 2.1,
                  viewportFraction: 1.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(
                left: width * 0.06, right: width * 0.05, top: height * 0.03),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Explore:',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20.0,
                    color: Colors.black),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(
                left: width * 0.05, right: width * 0.05, top: height * 0.01),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 1.3),
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                return index == 0
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CategoryProducts(
                                        categoryid: "1",
                                        categoryname: "Medium Pizza",
                                      )));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          //  height: height*0.12,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: height * 0.12,
                                padding: EdgeInsets.all(8.0),
                                child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(0.0)),
                                    child: Image.asset(imgListmenu[0],
                                        fit: BoxFit.contain)),
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Text(
                                'Medium Pizza',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15.0,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      )
                    : index == 1
                        ? GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CategoryProducts(
                                            categoryid: "2",
                                            categoryname: "Large Pizza",
                                          )));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: height * 0.12,
                                    padding: EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(0.0)),
                                        child: Image.asset(imgListmenu[2],
                                            fit: BoxFit.contain)),
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Text(
                                    'Large Pizza',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15.0,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : index == 2
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CategoryProducts(
                                                categoryid: "3",
                                                categoryname: "Combo\'s",
                                              )));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: height * 0.12,
                                        padding: EdgeInsets.all(8.0),
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(0.0)),
                                            child: Image.asset(imgListmenu[1],
                                                fit: BoxFit.contain)),
                                      ),
                                      SizedBox(
                                        height: height * 0.01,
                                      ),
                                      Text(
                                        'Combo\'s',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15.0,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CategoryProducts(
                                                categoryid: "4",
                                                categoryname: "Beverages",
                                              )));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: height * 0.12,
                                        padding: EdgeInsets.all(8.0),
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(0.0)),
                                            child: Image.asset(imgListmenu[3],
                                                fit: BoxFit.fill)),
                                      ),
                                      SizedBox(
                                        height: height * 0.01,
                                      ),
                                      Text(
                                        'Beverages',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15.0,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              );
              }, childCount: 4),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(
                left: width * 0.06, right: width * 0.05, top: height * 0.03),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Featured:',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20.0,
                    color: Colors.black),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(
                left: width * 0.06, right: width * 0.05, top: height * 0.03),
            sliver: SliverToBoxAdapter(
              child: Container(
                width: width,
                height: height * 0.23,
                child: ListView.builder(
                  itemCount: productList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5.0,
                      child: Container(
                        //margin: const EdgeInsets.all(10.0),
                        //  padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                height: height * 0.1,
                                width: width * 0.4,
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
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    productList[index].name ?? '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
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
                                  bottom: height * 0.01,
                                  left: width * 0.02,
                                  right: width * 0.02),
                              child: Text(
                                "€" + productList[index].price ?? '',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15.0,
                                    color: Colors.black),
                              ),
                            ),
                            Container(
                              width: width * 0.4,
                              margin: EdgeInsets.only(
                                  left: width * 0.02, right: width * 0.02),
                              height: height * 0.035,
                              child: RaisedButton(
                                onPressed: () {
                                  addtocartFunc(
                                      productList[index].productid.toString());
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'ADD TO CART',
                                      style: TextStyle(
                                          fontSize: 10.0, color: Colors.white),
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
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
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

  Future<void> dologout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLogged', false);
    await prefs.setString('col_user_id', '');

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
