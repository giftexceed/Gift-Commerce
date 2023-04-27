import 'package:flutter/material.dart';
import 'package:gift_mart/Providers/CartProvider.dart';
import 'package:provider/provider.dart';
import 'package:toggle_bar/toggle_bar.dart';

class CodToggleSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _cart = Provider.of<CartProvider>(context);
    return Container(
      color: Colors.white,
      child: ToggleBar(
          backgroundColor: Colors.grey[300],
          selectedTabColor: Theme.of(context).primaryColor,
          selectedTextColor: Colors.white,
          textColor: Colors.black,
          labels: const [
            "Pay Online",
            "Cash on Delivery",
          ],
          onSelectionUpdated: (index) {
            _cart.getPaymentMethod(index);
          }),
    );
  }
}
