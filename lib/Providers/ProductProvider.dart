import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ProductProvider with ChangeNotifier {
  String? selectedProduct;
  String? selectedProductId;
  DocumentSnapshot? productDetails;

  getSelectedProduct(productDetails) {
    this.productDetails = productDetails;
    notifyListeners();
  }
}
