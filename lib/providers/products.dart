import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';

import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  final String authToken;
  final String userId;

  Products (this.authToken, this.userId, this._items);

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fatchAndSetProduct ([bool filterByUser = false]) async {
    final filterString = filterByUser ? 'orderBy="creatorID"&equalTo=$userId' : '';
    var url = 'https://shop-app-fdbbb.firebaseio.com/products.json?auth=$authToken&$filterString';
    try{
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String,dynamic>;
      if (extractedData == null) {
        return false;
      }

      url = 'https://shop-app-fdbbb.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse =await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body) as Map<String,dynamic>;

      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData){
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorite: favoriteData[prodId] == null ? false : favoriteData[prodId] ?? false,
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = 'https://shop-app-fdbbb.firebaseio.com/products.json?auth=$authToken';
    try{
      final response = await http
          .post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId':userId,
        }),
      );

      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();

    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = 'https://shop-app-fdbbb.firebaseio.com/products/$id.json?auth=$authToken';

      try {
        await http.patch(url, body: json.encode({
          'title' : newProduct.title ,
          'description' : newProduct.description,
          'imageUrl' : newProduct.imageUrl,
          'price': newProduct.price,
        }));
        _items[prodIndex] = newProduct;
        notifyListeners();
      } catch (error) {
        throw error;
      }

    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = 'https://shop-app-fdbbb.firebaseio.com/products/$id.json?auth=$authToken';
    var existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    final response = await http.delete(url);

    _items.removeAt(existingProductIndex);
    notifyListeners();

    if (response.statusCode >= 400){
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete a product.');
    } else {
      existingProduct = null;
      existingProductIndex = null;
    }

  }
}