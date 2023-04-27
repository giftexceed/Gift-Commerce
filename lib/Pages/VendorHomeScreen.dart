import 'package:flutter/material.dart';
import 'package:gift_mart/Widgets/Products/RecentlyAddedProducts.dart';
import 'package:gift_mart/Widgets/VendorAppBar.dart';
import '../Widgets/CategoriesWidget.dart';
import '../Widgets/Products/BestSellingProduct.dart';
import '../Widgets/Products/FeaturedProducts.dart';
import '../Widgets/VendorBanner.dart';

class VendorHomeScreen extends StatelessWidget {
  static const String id = 'vendor-home-screen';
  @override
  Widget build(BuildContext context) {
    // StoreProvider _storeData = StoreProvider();
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            VendorAppBar(),
          ];
        },
        body: ListView(
          shrinkWrap: true,
          children: [
            VendorBanner(),
            VendorCategories(),
            RecentlyAddedProducts(),
            FeaturedProducts(),
            BestSellingProducts(),
          ],
        ),
      ),
    );
  }
}
