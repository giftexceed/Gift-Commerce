import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class StoreProvider with ChangeNotifier {
  User? user = FirebaseAuth.instance.currentUser;

  String? selectedStore;
  String? selectedStoreId;
  DocumentSnapshot? storeDetails;
  String? selectedProductCategory;
  String? selectedSubCategory;

  getSelectedStore(storeDetails) {
    this.storeDetails = storeDetails;
    notifyListeners();
  }

  selectedCategory(category) {
    this.selectedProductCategory = category;
    notifyListeners();
  }

  selectedCategorySub(subCategory) {
    this.selectedSubCategory = subCategory;
    notifyListeners();
  }
}
