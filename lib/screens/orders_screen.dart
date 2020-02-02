import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;

import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {

  static const String routeName = "/orders";

  @override
  Widget build(BuildContext context) {
    //final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar (
        title: Text('Your orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting){
            return Center (child: CircularProgressIndicator(),);
          } else {
            if (dataSnapshot.error != null){
              //... Have Error
              return Center(child: Text('Error!'),);
            } else {
              return Consumer<Orders>(
                builder: (ctx, ordersData, child) =>ListView.builder(
                  itemCount: ordersData.orders.length,
                  itemBuilder: (ctx,i) => OrderItem(ordersData.orders[i]),
                ),
              );
            }
          }
        }
      ),
    );
  }
}
