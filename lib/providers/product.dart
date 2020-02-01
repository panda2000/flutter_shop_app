import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void toggleFavoriteStatus() async {
    var oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final url = 'https://shop-app-fdbbb.firebaseio.com/products/$id.json';
    try {
      final respone = await http.patch(
          url,
          body: json.encode({
            'isFavorite': isFavorite,
          })
      );

      if (respone.statusCode >= 400) {
        throw HttpException('Update Favorite fail');
      } else {
        oldStatus = null;
      }
    } catch (error) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}
