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
  final String useId;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    @required this.useId,
    this.isFavorite = false,
  });

  void toggleFavoriteStatus(String authToken, String userId) async {
    var oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final url = 'https://shop-app-fdbbb.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken';
    try {
      final respone = await http.put(
          url,
          body: json.encode(
            isFavorite,
          )
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
