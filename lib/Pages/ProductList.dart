import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/StoreProvider.dart';
import '../Widgets/Products/ProductFilterWidget.dart';
import '../Widgets/Products/ProductListWidget.dart';

class ProductList extends StatelessWidget {
  static const String id = 'product-list';
  @override
  Widget build(BuildContext context) {
    var _storeProvider = Provider.of<StoreProvider>(context);
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
            floating: true,
            snap: true,
            title: Text(_storeProvider.selectedProductCategory!,
                style: const TextStyle(color: Colors.white)),
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            expandedHeight: 110,
            flexibleSpace: Padding(
              padding: const EdgeInsets.only(top: 88),
              child: Container(
                height: 56,
                color: Colors.grey,
                child: ProductFilterWidget(),
              ),
            ),
          ),
        ];
      },
      body: ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: [
          ProductListWidget(),
        ],
      ),
    ));
  }
}
