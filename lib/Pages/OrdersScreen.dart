import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Providers/OrderProvider.dart';
import '../Services/OrderServices.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  OrderServices _orderServices = OrderServices();
  User? user = FirebaseAuth.instance.currentUser;

  int tag = 0;
  List<String> options = [
    'All Orders',
    'Ordered',
    'Accepted',
    'Picked Up',
    'On the way',
    'Delivered',
    'Rejected',
  ];

  @override
  Widget build(BuildContext context) {
    var orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
          title: const Text('My Orders', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(CupertinoIcons.search, color: Colors.white),
              onPressed: () {},
            )
          ]),
      body: Column(
        children: [
          Container(
            height: 56,
            width: MediaQuery.of(context).size.width,
            child: ChipsChoice<int>.single(
              value: tag,
              onChanged: (val) {
                if (val == 0) {
                  setState(() {
                    orderProvider.status = null;
                  });
                }
                setState(() {
                  tag = val;
                  orderProvider.status = options[val];
                });
              },
              choiceItems: C2Choice.listFrom<int, String>(
                source: options,
                value: (i, v) => i,
                label: (i, v) => v,
              ),
            ),
          ),
          Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: _orderServices.orders
                  .where('userId', isEqualTo: user!.uid)
                  .where('orderStatus',
                      isEqualTo: tag > 0 ? orderProvider.status : null)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.size == 0) {
                  return Center(
                    child: Text(tag > 0
                        ? '${options[tag]} category is empty'
                        : 'You have no order. Buy something today...'),
                  );
                }

                return Expanded(
                  child: ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      return Container(
                          color: Colors.white,
                          child: Column(children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 14,
                                child: _orderServices.statusIcon(
                                    document, context),
                              ),
                              title: Text(document['orderStatus'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _orderServices.statusColour(
                                        document, context),
                                    fontWeight: FontWeight.bold,
                                  )),
                              subtitle: Text(
                                  'On ${DateFormat.yMMMd().format(
                                    DateTime.parse(document['timestamp']),
                                  )}',
                                  style: const TextStyle(fontSize: 12)),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                      'Amount: \NGN${document['total'].toStringAsFixed(0)}',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      'Payment Method: ${document['cod'] == true ? 'Cash on delivery' : 'Online payment'}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                      )),
                                ],
                              ),
                            ),
                            // Delivery boy contact area goes here
                            if (document['deliveryBoy']['name'].length > 2)
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: ListTile(
                                  tileColor: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(.5),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: document['deliveryBoy']['image'] ==
                                            null
                                        ? Container()
                                        : Image.network(
                                            document['deliveryBoy']['image'],
                                            height: 24),
                                  ),
                                  title: Text(document['deliveryBoy']['name']),
                                  subtitle: Text(
                                      _orderServices.statusComment(document)),
                                ),
                              ),
                            ExpansionTile(
                              title: const Text(
                                'Order details',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black),
                              ),
                              subtitle: const Text(
                                'view order details',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ListTile(
                                      leading: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Image.network(
                                              document['products'][index]
                                                  ['productImage'])),
                                      title: Text(document['products'][index]
                                          ['productName']),
                                      subtitle: Text(
                                          'NGN${document['products'][index]['price'].toStringAsFixed(0)} x qty (${document['products'][index]['quantity']}) = ${document['products'][index]['total'].toStringAsFixed(0)},',
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12)),
                                    );
                                  },
                                  itemCount: document['products'].length,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12, top: 8, bottom: 8),
                                  child: Card(
                                    elevation: 4,
                                    // color: Theme.of(context)
                                    //     .primaryColor
                                    //     .withOpacity(.6),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(children: [
                                        Row(children: [
                                          const Text('Seller: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12)),
                                          Text(
                                            document['seller']['shopName'],
                                            style:
                                                (const TextStyle(fontSize: 12)),
                                          )
                                        ]),
                                        const SizedBox(height: 10),
                                        if (int.parse(document['discount']) > 0)
                                          Column(children: [
                                            Row(children: [
                                              const Text('Discount: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12)),
                                              Text(
                                                '\NGN${document['discount']}',
                                              )
                                            ]),
                                            const SizedBox(height: 10),
                                            Row(children: [
                                              const Text('Discount Code: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12)),
                                              Text(
                                                  '${document['discountCode']}',
                                                  style: const TextStyle(
                                                      fontSize: 12))
                                            ])
                                          ]),
                                        const SizedBox(height: 10),
                                        Row(children: [
                                          const Text('Delivery Fee: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12)),
                                          Text(
                                              'NGN${document['deliveryFee'].toString()}',
                                              style:
                                                  const TextStyle(fontSize: 12))
                                        ])
                                      ]),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const Divider(height: 3, color: Colors.grey)
                          ]));
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
