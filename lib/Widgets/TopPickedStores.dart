import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gift_mart/Services/StoreServices.dart';
import 'package:provider/provider.dart';

import '../Providers/StoreProvider.dart';

class TopPickedStores extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    StoreServices _storeServices = StoreServices();
    // StoreProvider _storeData = StoreProvider();
    var _storeData = Provider.of<StoreProvider>(context);

    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: _storeServices.getTopPickedStores(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot) {
          if (!snapShot.hasData) return const CircularProgressIndicator();
          // List shopsNearBy = [];
          // for (int i = 0; i <= snapShot.data.docs.length; i++) {
          //   var distance = Geolocator.distanceBetween(
          //       _userLatitude,
          //       _userLongitude,
          //       snapShot.data.docs[i]['location'].latitude,
          //       snapShot.data.docs[i]['location'].longitude);
          //   var distanceInKm = distance / 1000;

          //   shopsNearBy.add(distanceInKm);
          // }

          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8, right: 8, top: 20),
                child: Text('Top Picked Stores',
                    style:
                        TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
              ),
              Flexible(
                child: ListView(
                    scrollDirection: Axis.horizontal,
                    children:
                        snapShot.data!.docs.map((DocumentSnapshot document) {
                      return InkWell(
                        onTap: () {
                          _storeData.getSelectedStore(document);
                          // pushNewScreenWithRouteSettings(
                          //   context,
                          //   settings: RouteSettings(name: VendorHomeScreen.id),
                          //   screen: VendorHomeScreen(),
                          //   withNavBar: true,
                          //   pageTransitionAnimation:
                          //       PageTransitionAnimation.cupertino,
                          // );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Stack(
                            children: [
                              Container(
                                width: 120,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          SizedBox(
                                              width: 100,
                                              height: 100,
                                              child: Card(
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    child: Image.network(
                                                        document['shopImage'],
                                                        fit: BoxFit.cover)),
                                              )),
                                        ],
                                      ),
                                      Container(
                                          child: Text(
                                        document['shopName'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                      Text(
                                          document['shopCity'] +
                                              ' - ' +
                                              document['shopState'],
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 10,
                                          )),
                                      // Text('${getDistance(document['location'])}Km',
                                      //     style: TextStyle(
                                      //       color: Colors.grey,
                                      //       fontSize: 10,
                                      //     ))
                                    ]),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList()),
              )
            ],
          );
        },
      ),
    );
  }
}
