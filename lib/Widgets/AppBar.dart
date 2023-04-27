import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:search_page/search_page.dart';

import '../Models/ProductModel.dart';
import 'Products/AllProductSearch.dart';

class MyAppBar extends StatefulWidget {
  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  static List<AllProduct> allProducts = [];
  String? offer;
  String? shopName;
  DocumentSnapshot? document;

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          document = doc;
          offer = ((doc['comparedPrice'] - doc['price']) /
                  (doc['comparedPrice']) *
                  100)
              .toStringAsFixed(00);
          allProducts.add(AllProduct(
            brand: doc['brand'],
            price: doc['price'],
            category: doc['category']['mainCategory'],
            image: doc['productImage'],
            productName: doc['productName'],
            document: doc,
          ));
        });
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    allProducts.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final locationData = Provider.of<LocationProvider>(context);
    // return AppBar ( non-scrollable App Bar
    return SliverAppBar(
      automaticallyImplyLeading: false,
      elevation: 0.0,
      floating: true,
      snap: true,
      title: const Text('Ahia',
          style: TextStyle(
            fontFamily: 'Signatra',
            color: Colors.white,
            fontSize: 40,
            // fontWeight: FontWeight.bold,
          )),
      actions: [
        // IconButton(
        //   icon: Icon(Icons.power_settings_new, color: Colors.white),
        //   onPressed: () {
        //     FirebaseAuth.instance.signOut();
        //     Navigator.pushReplacementNamed(context, WelcomeScreen.id);
        //   },
        // ),
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white, size: 30),
          onPressed: () {
            showSearch(
                context: context,
                delegate: SearchPage<AllProduct>(
                  onQueryUpdate: (s) => print(s),
                  items: allProducts,
                  searchLabel: 'Search product',
                  suggestion: const Center(
                    child: Text(
                      'Filter product by category, name or price',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  failure: const Center(
                    child: Text('No product found :(',
                        style: TextStyle(fontSize: 20)),
                  ),
                  filter: (products) => [
                    products.productName!,
                    products.category!,
                    products.brand!,
                    products.price.toString(),
                  ],
                  builder: (allProducts) => AllProductSearch(
                    offer: offer!,
                    allProducts: allProducts,
                    document: allProducts.document!,
                  ),
                ));
          },
        ),
      ],
      centerTitle: true,
    );
  }
}
