import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gift_mart/Providers/CartProvider.dart';
import 'package:provider/provider.dart';

class CartNotification extends StatefulWidget {
  @override
  _CartNotificationState createState() => _CartNotificationState();
}

class _CartNotificationState extends State<CartNotification> {
  // CartServices _cart = CartServices();
  // DocumentSnapshot document;

  @override
  Widget build(BuildContext context) {
    final _cartProvider = Provider.of<CartProvider>(context);
    _cartProvider.getCartTotal();
    _cartProvider.getShopName();

    return Visibility(
      visible: _cartProvider.cartQty > 0 ? true : false,
      child: Container(
        height: 30,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        // color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${_cartProvider.cartQty}${_cartProvider.cartQty == 1 ? ' item in cart' : ' items in cart'}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(' | ',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                        Text(
                          'Sub-Total: NGN${_cartProvider.subTotal.toStringAsFixed(0)}',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {},
                child: Row(children: const [
                  Text('View Cart',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  SizedBox(width: 5),
                  Icon(CupertinoIcons.cart_fill, color: Colors.red)
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
