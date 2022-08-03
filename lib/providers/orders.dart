import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String? authToken;

  Orders(this.authToken, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
      'https://shopacc-117e8-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json?auth=$authToken',
    );
    final response = await http.get(url);
    // print(json.decode(response.body));
    final List<OrderItem> loadedOrders = List.empty(growable: true);

    if (json.decode(response.body) == null || response.statusCode != 200) {
      return;
    }
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
        id: orderId,
        amount: orderData['amount'],
        dateTime: DateTime.parse(orderData['dateTime']),
        products: (orderData['products'] as List<dynamic>)
            .map(
              (e) => CartItem(
                id: e['id'],
                title: e['title'],
                quantity: e['quantity'],
                price: e['price'],
              ),
            )
            .toList(),
      ));
    });
    _orders = loadedOrders.reversed.toList();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
      'https://shopacc-117e8-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json?auth=$authToken',
    );
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProducts
            .map((e) => {
                  'id': e.id,
                  'title': e.title,
                  'quantity': e.quantity,
                  'price': e.price,
                })
            .toList(),
      }),
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: DateTime.now(),
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
