import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  static const String routeName = "/product_detail";

  @override
  Widget build(BuildContext context) {
    final productId =  ModalRoute.of(context).settings.arguments as String; // is the id!
    // ...
    return Scaffold(
      appBar: AppBar(
        title: Text('Title'),
      ),
    );
  }
}
