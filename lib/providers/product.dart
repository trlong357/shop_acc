import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus() async {
    // print(id);

    final url = Uri.parse(
      'https://shopacc-117e8-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json',
    );
    final response = await http.patch(url,
        body: json.encode(
          {
            'isFavorite': !isFavorite,
          },
        ));
    if (response.statusCode == 200) {
      isFavorite = !isFavorite;
      notifyListeners();
    } else {
      // print("Something wrong!");
      return;
    }
  }
}
