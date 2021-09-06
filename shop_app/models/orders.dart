import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/models/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime timePlaced;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.timePlaced,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String token;
  final String userId;

  Orders(this.token, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://fluttershopapp-d31ee.firebaseio.com/orders/$userId.json?auth=$token';
    final resp = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final data = json.decode(resp.body) as Map<String, dynamic>;
    if (data != null) {
      data.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          timePlaced: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title'],
                ),
              )
              .toList(),
        ));
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    }
  }

  Future<void> addOrder(List<CartItem> cartProds, double total) async {
    final url =
        'https://fluttershopapp-d31ee.firebaseio.com/orders/userId.json?auth=$token';
    final orderDT = DateTime.now();
    final resp = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': orderDT.toIso8601String(),
        'products': cartProds
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList()
      }),
    );
    _orders.insert(
      0,
      OrderItem(
          id: json.decode(resp.body)['name'],
          amount: total,
          products: cartProds,
          timePlaced: orderDT),
    );
    notifyListeners();
  }
}
