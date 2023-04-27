import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gift_mart/Widgets/Products/ProductCardWidget.dart';
import 'package:provider/provider.dart';

import '../../Providers/StoreProvider.dart';
import '../../Services/ProductServices.dart';

class ProductListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProductServices _services = ProductServices();
    var _storeProvider = Provider.of<StoreProvider>(context);
    return FutureBuilder<QuerySnapshot>(
      future: _services.product
          .where('published', isEqualTo: true)
          .where('category.mainCategory',
              isEqualTo: _storeProvider.selectedProductCategory)
          .where('category.subCategory',
              isEqualTo: _storeProvider.selectedSubCategory)
          .where('seller.sellerUid',
              isEqualTo: _storeProvider.storeDetails!['uid'])
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data!.docs.isEmpty) {
          return Container();
        }

        return Column(
          children: [
            // ProductFilterWidget(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: FittedBox(
                        child: Row(
                      children: [
                        snapshot.data!.docs.length <= 1
                            ? Text('${snapshot.data!.docs.length} Item',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold))
                            : Text('${snapshot.data!.docs.length} Items',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    )),
                  ),
                ),
              ),
            ),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                return ProductCard(document);
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
