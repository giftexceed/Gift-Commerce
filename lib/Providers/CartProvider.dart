import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gift_mart/Services/CartServices.dart';

class CartProvider with ChangeNotifier {
  CartServices _cart = CartServices();
  double subTotal = 0.0;
  int cartQty = 0;
  QuerySnapshot? snapshot;
  DocumentSnapshot? document;
  double saving = 0.0;
  bool cod = false;
  List cartList = [];

  Future<double> getCartTotal() async {
    var cartTotal = 0.0;
    var saving = 0.0;
    List _newList = [];
    QuerySnapshot snapshot =
        await _cart.cart.doc(_cart.user!.uid).collection('products').get();

    for (var doc in snapshot.docs) {
      if (!_newList.contains(doc)) {
        _newList.add(doc.data());
        cartList = _newList;
        notifyListeners();
      }
      cartTotal = cartTotal + doc['total'];
      saving = saving +
          ((doc['comparedPrice'] - doc['price']) > 0
              ? doc['comparedPrice'] - doc['price']
              : 0);
    }

    subTotal = cartTotal;
    cartQty = snapshot.size;
    this.snapshot = snapshot;
    this.saving = saving;
    notifyListeners();

    return cartTotal;
  }

  getPaymentMethod(index) {
    if (index == 0) {
      cod = false;
      notifyListeners();
    } else {
      cod = true;
      notifyListeners();
    }
  }

  getShopName() async {
    DocumentSnapshot doc = await _cart.cart.doc(_cart.user!.uid).get();
    if (doc.exists) {
      document = doc;
      notifyListeners();
    } else {
      document = null;
      notifyListeners();
    }
  }
}
