import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:test_app/model/ProductData.dart';

class HomeController extends GetxController {
  List<AllProductData> arrProducts = [];

  void addProductData(
    DatabaseReference databaseReference, {
    String productName = "",
    String productDetails = "",
    String productCompanyName = "",
  }) {
    Map<String, String> product = Map();
    product["productName"] = productName;
    product["productDetails"] = productDetails;
    product["productCompanyName"] = productCompanyName;
    databaseReference.push().set(product).then((value) => print("Success"));
    printFirebase(databaseReference);
    Get.back();
  }

  void printFirebase(DatabaseReference databaseReference) {
    databaseReference.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> dictProducts = snapshot.value;
      arrProducts.clear();
      dictProducts.forEach((key, value) {
        Map<dynamic, dynamic> products = dictProducts[key];
        arrProducts.add(AllProductData.fromJson(products));
      });
      update();
    });
    update();
  }

  Widget titleDisplay({String title =''}){
    return Text(
      title,
      style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold),
    );
  }
}
