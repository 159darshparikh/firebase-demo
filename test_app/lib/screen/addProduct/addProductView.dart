import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/controller/homeController.dart';

class AddProductView extends StatefulWidget {
  @override
  AddProductViewState createState() => AddProductViewState();
}

class AddProductViewState extends State<AddProductView> {
  String _productName = "";
  String _productDetails = "";
  String _productCompany = "";
  final databaseRef = FirebaseDatabase.instance.reference().child("allProduct");
  HomeController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Product Name',
                ),
                onChanged: (value) {
                  _productName = value;
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Product details',
                ),
                onChanged: (value) {
                  _productDetails = value;
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Product company name',
                ),
                onChanged: (value) {
                  _productCompany = value;
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              RaisedButton(
                  color: Colors.black,
                  child: Text("Save to Database",style: TextStyle(color: Colors.white),),
                  onPressed: () {
                    _controller.addProductData(databaseRef,
                        productCompanyName: _productCompany,
                        productDetails: _productDetails,
                        productName: _productName);
                    //call method flutter upload
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
