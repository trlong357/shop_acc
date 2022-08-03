import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'product.dart';

import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  final String? authToken;

  final String? userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndSetProducts([bool fetchItemByUser = false]) async {
    String fetchByUser =
        fetchItemByUser == true ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    final url = Uri.parse(
        'https://shopacc-117e8-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken&$fetchByUser');
    try {
      final response = await http.get(url);
      // print(json.decode(response.body).runtimeType);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final loadedProducts = List<Product>.empty(growable: true);

      final favUrl = Uri.parse(
        'https://shopacc-117e8-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId.json?auth=$authToken',
      );

      final favoriteResponse = await http.get(favUrl);
      final favoriteData = json.decode(favoriteResponse.body);
      extractedData.forEach(
        (prodId, prodData) {
          loadedProducts.add(
            Product(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              imageUrl: prodData['imageUrl'],
              price: prodData['price'],
              isFavorite:
                  favoriteData == null ? false : favoriteData[prodId] ?? false,
            ),
          );
        },
      );
      _items = loadedProducts;
      notifyListeners();
    } catch (err) {
      // print(err);
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://shopacc-117e8-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'creatorId': userId,
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
      // print(error);
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final proIndex = _items.indexWhere((element) => element.id == id);
    if (proIndex >= 0) {
      final url = Uri.parse(
          'https://shopacc-117e8-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken');
      try {
        await http.patch(url,
            body: json.encode({
              'title': newProduct.title,
              'description': newProduct.description,
              'price': newProduct.price,
              'imageUrl': newProduct.imageUrl,
            }));
        _items[proIndex] = newProduct;

        notifyListeners();
      } catch (error) {
        // print(error);
      }
    } else {
      // print("...");
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://shopacc-117e8-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken');

    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);

    dynamic existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}
