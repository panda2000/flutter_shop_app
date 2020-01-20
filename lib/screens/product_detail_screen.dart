import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const String routeName = "/product_detail";

  @override
  Widget build(BuildContext context) {
    final productId =  ModalRoute.of(context).settings.arguments as String; // is the id!
    Provider.of<Products>(
      context,
      listen: false,
    ).findById(
        productId
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Title'),
      ),
    );
  }
}
