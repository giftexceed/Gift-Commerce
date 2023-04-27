import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gift_mart/Widgets/Products/BottomSheetContainer.dart';

class ProductDetails extends StatelessWidget {
  static const String id = 'product-details';
  final DocumentSnapshot document;

  const ProductDetails({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    String offer = ((document['comparedPrice'] - document['price']) /
            (document['comparedPrice']) *
            100)
        .toStringAsFixed(00);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.search),
            onPressed: () {},
          )
        ],
      ),
      bottomSheet: BottomSheetContainer(document),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView(
          shrinkWrap: true,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(.3),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8, bottom: 2, top: 2),
                    child: Text(document['brand']),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(document['productName'],
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                Text('\NGN${document['price'].toStringAsFixed(0)}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                if (document['comparedPrice'] > document['price'])
                  Text(
                    '\NGN${document['comparedPrice'].toStringAsFixed(0)}',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.lineThrough),
                  ),
                const SizedBox(width: 10),
                if (document['comparedPrice'] > document['price'])
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 3, bottom: 3),
                      child: Text('$offer% OFF',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 12)),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Hero(
                  tag: 'product${document['productName']}',
                  child: Image.network(document['productImage'])),
            ),
            Divider(color: Colors.grey[300], thickness: 6),
            Container(
                child: const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: Text('About this product', style: TextStyle(fontSize: 20)),
            )),
            Divider(color: Colors.grey[300], thickness: 6),
            Padding(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
              child: ExpandableText(
                document['productDescription'],
                expandText: 'read more',
                collapseText: 'show less',
                maxLines: 3,
                linkColor: Colors.blue,
                // style: TextStyle(color: Colors.grey),
              ),
            ),
            Divider(color: Colors.grey[400]),
            Container(
                child: const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: Text('Products Images', style: TextStyle(fontSize: 20)),
            )),
            Divider(color: Colors.grey[400]),
            if (document['productImages1'] != "")
              Padding(
                padding: const EdgeInsets.all(20),
                child: Hero(
                    tag: 'product images',
                    child: Image.network(document['productImages1'])),
              ),
            if (document['productImages2'] != "")
              Padding(
                padding: const EdgeInsets.all(20),
                child: Hero(
                    tag: 'product images',
                    child: Image.network(document['productImages2'])),
              ),
            if (document['productImages3'] != "")
              Padding(
                padding: const EdgeInsets.all(20),
                child: Hero(
                    tag: 'product images',
                    child: Image.network(document['productImages3'])),
              ),
            if (document['productImages4'] != "")
              Padding(
                padding: const EdgeInsets.all(20),
                child: Hero(
                    tag: 'product images',
                    child: Image.network(document['productImages4'])),
              ),
            if (document['productImages5'] != "")
              Padding(
                padding: const EdgeInsets.all(20),
                child: Hero(
                    tag: 'product images',
                    child: Image.network(document['productImages5'])),
              ),
            if (document['productImages6'] != "")
              Padding(
                padding: const EdgeInsets.all(20),
                child: Hero(
                    tag: 'product images',
                    child: Image.network(document['productImages6'])),
              ),
            Divider(color: Colors.grey[400]),
            Padding(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Seller: ${document['seller']['shopName']}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20))
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Text('Star rating ***'),
            // Text('Comment area'),
            const SizedBox(height: 100)
          ],
        ),
      ),
    );
  }
}
