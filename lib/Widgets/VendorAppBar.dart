import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search_page/search_page.dart';

import '../Models/ProductModel.dart';
import '../Providers/StoreProvider.dart';
import 'Products/SearchCardWidget.dart';

class VendorAppBar extends StatefulWidget {
  @override
  _VendorAppBarState createState() => _VendorAppBarState();
}

class _VendorAppBarState extends State<VendorAppBar> {
  static List<Product> products = [];
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
          products.add(Product(
            brand: doc['brand'],
            price: doc['price'],
            category: doc['category']['mainCategory'],
            image: doc['productImage'],
            productName: doc['productName'],
            shopName: doc['seller']['shopName'],
            document: doc,
          ));
        });
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    products.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _storeData = Provider.of<StoreProvider>(context);

    return SliverAppBar(
      floating: true,
      snap: true,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              shopName = _storeData.storeDetails!['shopName'];
            });
            showSearch(
                context: context,
                delegate: SearchPage<Product>(
                  onQueryUpdate: (s) => print(s),
                  items: products,
                  searchLabel: 'Search product',
                  suggestion: Center(
                    child: Text('Filter product by category, name or price'),
                  ),
                  failure: Center(
                    child: Text('No product found :('),
                  ),
                  filter: (products) => [
                    products.productName!,
                    products.category!,
                    products.brand!,
                    products.price.toString(),
                  ],
                  builder: (products) => shopName != products.shopName
                      ? Container()
                      : SearchCard(
                          offer: offer!,
                          products: products,
                          document: products.document!,
                        ),
                ));
          },
          icon: Icon(CupertinoIcons.search),
        )
      ],
      title: Text(_storeData.storeDetails!['shopName'],
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }
}
