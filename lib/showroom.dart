import 'package:flutter/material.dart';
import 'package:rentwheels/data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentwheels/car_widget.dart';
import 'package:rentwheels/book_car.dart';
import 'package:rentwheels/car_type.dart';
import 'package:rentwheels/newly_added_car.dart';
import 'package:rentwheels/profile.dart';
import 'package:rentwheels/date_time.dart';
import 'package:rentwheels/notification.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Showroom extends StatefulWidget {
  const Showroom({super.key});

  @override
  State<Showroom> createState() => _ShowroomState();
}

class _ShowroomState extends State<Showroom> {

  final currentuser = FirebaseAuth.instance.currentUser!;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  List<Car> cars = getCarList();
  List<Dealer> dealers = getDealerList();
  List<carType> carTypes = getCarTypeList();

  Future<String> getDownloadURL(String gsUri) async {
    String path = gsUri.replaceFirst('gs://rentwheels-32bd9.firebasestorage.app/', ''); // Replace with your actual bucket name
    return await FirebaseStorage.instance.ref(path).getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "RentWheels",
          style: GoogleFonts.mulish(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationPage()),
                );
              },
              child: Stack(
                children: [
                  Icon(
                    Icons.notifications,
                    color: Colors.black,
                    size: 28,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '3', // Replace with a dynamic notification count
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile()),
                );
              },
              child: Icon(
                Icons.person,
                color: Colors.black,
                size: 28,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(),
            child: IconButton(
            onPressed: signUserOut,
            icon: Icon(Icons.logout_outlined, color: Colors.black,),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DateTimeSelectionPage()),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.only(left: 30, right: 24, top: 16, bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Select Date & Time",
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        Icon(
                          Icons.calendar_month,
                          color: Colors.black,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "TOP CARS",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 280,
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: buildDeals(),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewlyAddedCars()),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 16, right: 16, left: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue[500],
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        padding: EdgeInsets.all(24),
                        height: 110,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Newly Added",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "Cars",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  )),
                              height: 50,
                              width: 50,
                              child: Center(
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "CHOOSE BY CAR TYPE",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 150,
                    margin: EdgeInsets.only(bottom: 16),
                    child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    children: buildCarTypeList(),
                  ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildDeals() {
    List<Widget> list = [];
    for (var i = 0; i < cars.length; i++) {
      list.add(
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BookCar(car: cars[i])),
            );
          },
          child: buildCar(cars[i], i),
        ),
      );
    }
    return list;
  }


  List<Widget> buildCarTypeList() {
  List<Widget> list = [];
  for (var i = 0; i < carTypes.length; i++) {
    list.add(buildCarType(carTypes[i], i));
  }
  return list;
}
}