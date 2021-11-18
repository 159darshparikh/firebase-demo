class AllProductData {
  AllProductData({
    required this.productCompanyName,
    required this.productDetails,
    required this.productName,
  });
  late final String productCompanyName;
  late final String productDetails;
  late final String productName;

  AllProductData.fromJson(Map<dynamic, dynamic> json){
    productCompanyName = json['productCompanyName'];
    productDetails = json['productDetails'];
    productName = json['productName'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['productCompanyName'] = productCompanyName;
    _data['productDetails'] = productDetails;
    _data['productName'] = productName;
    return _data;
  }
}