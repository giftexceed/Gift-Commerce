import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gift_mart/Providers/StoreProvider.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import '../Services/ProductServices.dart';

class VendorCategories extends StatefulWidget {
  @override
  _VendorCategoriesState createState() => _VendorCategoriesState();
}

class _VendorCategoriesState extends State<VendorCategories> {
  final ProductServices _services = ProductServices();
  final List _catList = [];

  @override
  void didChangeDependencies() {
    var store = Provider.of<StoreProvider>(context);

    FirebaseFirestore.instance
        .collection('products')
        .where('seller.sellerUid', isEqualTo: store.storeDetails!['uid'])
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                setState(() {
                  _catList.add(doc['category']['mainCategory']);
                });
              }),
            });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var storeProvider = Provider.of<StoreProvider>(context);

    return FutureBuilder(
      future: _services.category.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong...'));
        }
        if (_catList.length == 0) {
          return const Center(
            child: Text(''),
          );
        }
        if (!snapshot.hasData) {
          return Container();
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: const Center(
                      child: FittedBox(
                        child: Text('Shop by Category',
                            style: TextStyle(
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(2.0, 2.0),
                                  blurRadius: 3.0,
                                  color: Colors.black,
                                )
                              ],
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )),
                      ),
                    ),
                  ),
                ),
              ),
              Wrap(
                direction: Axis.horizontal,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  return _catList.contains(document['categoryName'])
                      ? InkWell(
                          onTap: () {
                            storeProvider
                                .selectedCategory(document['categoryName']);
                            storeProvider.selectedCategorySub(null);
                          },
                          child: SizedBox(
                            width: 120,
                            height: 150,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: .3,
                                  )),
                              child: Column(
                                children: [
                                  Center(
                                      child: Image.network(
                                          document['productImage'])),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8),
                                    child: Text(
                                      document['categoryName'],
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : const Text('');
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
