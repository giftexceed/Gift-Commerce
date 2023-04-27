import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gift_mart/Widgets/Products/SaveForLater.dart';

import 'AddToCartWidget.dart';

class BottomSheetContainer extends StatefulWidget {
  final DocumentSnapshot document;

  BottomSheetContainer(this.document);

  @override
  _BottomSheetContainerState createState() => _BottomSheetContainerState();
}

class _BottomSheetContainerState extends State<BottomSheetContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Flexible(flex: 1, child: SaveForLater(widget.document)),
          Flexible(flex: 1, child: AddToCartWidget(widget.document)),
        ],
      ),
    );
  }
}
