import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/products.dart';
import 'package:provider/provider.dart';

import '../widgets/product_grid.dart';

enum FilterOptions {
  Favorite,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State <ProductsOverviewScreen>{

  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    //final productrsContaner =Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar (
        title: Text ('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                print (selectedValue);
                if (selectedValue == FilterOptions.Favorite){
                  //     productrsContaner.showFavoritesOnly();
                  _showOnlyFavorites = true;
                } else {
                  //     productrsContaner.showAll();
                  _showOnlyFavorites = false;
                }
              });

            },
            icon: Icon(Icons.more_vert, ),
            itemBuilder: (_) => [
              PopupMenuItem( child: Text('Only Favorites'), value: FilterOptions.Favorite),
              PopupMenuItem( child: Text('Show All'), value: FilterOptions.All)
            ],
          ),
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: ProductsGrid(_showOnlyFavorites),
    );
  }

}
