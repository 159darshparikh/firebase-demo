import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:test_app/screen/dashboard/dashboardView.dart';

class MyDetailsView extends StatefulWidget {
  final String email;
  final String password;

  MyDetailsView({this.email = "", this.password = ""});

  @override
  MyDetailsViewState createState() => MyDetailsViewState();
}

class MyDetailsViewState extends State<MyDetailsView> {
  String _age = "";
  String _gender = "";
  final databaseRef = FirebaseDatabase.instance.reference().child("user");

  //List<ProdductData> productData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Age',
                ),
                onChanged: (value) {
                  _age = value;
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Gender',
                ),
                onChanged: (value) {
                  _gender = value;
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              RaisedButton(
                  color: Colors.black,
                  child: Text(
                    "Save to Database",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    print("--------------- ADD DATA------------------");
                    addData(age: _age, gender: _gender);
                    //call method flutter upload
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void addData({String age = "", String gender = ""}) {
    print("-------------- FUNCTION CALL-----------------");
    Map<String, String> user = Map();
    user["age"] = age;
    user["gender"] = gender;
    user["email"] = widget.email;
    user["password"] = widget.password;
    databaseRef.push().set(user).then((value) {
      Get.offAll(DashboardView(
        userMap: user,
      ));
    });
  }

  void printFirebase() {
    databaseRef.once().then((DataSnapshot snapshot) {
      print('Data : ${snapshot.value}');
    });
  }
}
