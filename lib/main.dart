import 'package:flutter/material.dart';


import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_prodict_screen.dart';
import './screens/auth-screen.dart';

import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          builder: (ctx,auth, previosProducts) => Products(
              auth.token,
              auth.userId,
              previosProducts == null ? [] : previosProducts.items
          )
        ),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          builder: (ctx, auth, previosOrders) =>  Orders(
            auth.token,
            previosOrders == null ? [] : previosOrders.orders
          )
        ),
      ],
      child: Consumer<Auth>(builder: (ctx,authData, _) =>
          MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              backgroundColor: Colors.white70,
            ),
            home: authData.isAuth ? ProductsOverviewScreen() : AuthScreen(),
            routes: {
              ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen (),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
              AuthScreen.routeName: (ctx) => AuthScreen(),
            },
          ),
      ),
    );
  }
}


