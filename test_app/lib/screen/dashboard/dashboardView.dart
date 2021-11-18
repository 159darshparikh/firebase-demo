import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/controller/homeController.dart';
import 'package:test_app/model/ProductData.dart';
import 'package:test_app/screen/addProduct/addProductView.dart';

class DashboardView extends StatefulWidget {
  final Map<String, String> userMap;

  // receive data from the FirstScreen as a parameter
  DashboardView({required this.userMap});

  @override
  DashboardViewState createState() => DashboardViewState();
}

class DashboardViewState extends State<DashboardView> {
  var _controller = Get.put(HomeController());
  final databaseRef = FirebaseDatabase.instance.reference().child("allProduct");

  @override
  void initState() {
    _controller.printFirebase(databaseRef);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _controller.titleDisplay(
                    title: "${widget.userMap['email']} Welcome to dashboard"),
                SizedBox(
                  height: 10,
                ),
                Expanded(child:
                    GetBuilder<HomeController>(builder: (homeController) {
                  return Container(
                    child: ListView.builder(
                        itemCount: homeController.arrProducts.length,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          AllProductData productData =
                              homeController.arrProducts[index];
                          int displayIndex = index + 1;
                          return Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 0.5, color: Colors.grey),
                              borderRadius: BorderRadius.all(Radius.circular(
                                      5.0) //                 <--- border radius here
                                  ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5, color: Colors.grey),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                100.0) //                 <--- border radius here
                                            ),
                                      ),
                                      child: Text(
                                        "$displayIndex",
                                        style: TextStyle(
                                            fontSize: 21.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      height: 50.0,
                                      width: 50.0,
                                      alignment: Alignment.center,
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          productData.productName,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          child: Text(
                                              productData.productCompanyName),
                                          margin: EdgeInsets.symmetric(
                                              vertical: 5.0),
                                        ),
                                        Text(
                                          'Details : ${productData.productDetails}',
                                          style:
                                              TextStyle(color: Colors.black54),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        }),
                  );
                }))
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () {
              Get.to(AddProductView());
            },
            tooltip: "Add product",
            elevation: 0.0,
            child: Icon(Icons.add)));
  }
}
