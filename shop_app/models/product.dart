import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String desc;
  final double price;
  final String imageUrl;
  bool isFav;

  Product({
    @required this.id,
    @required this.title,
    @required this.desc,
    @required this.price,
    @required this.imageUrl,
    this.isFav = false,
  });

  void _setFavValue(bool value) {
    isFav = value;
    notifyListeners();
  }

  Future<void> toggleFav(String token, String userId) async {
    final oldStatus = isFav;
    _setFavValue(!isFav);
    final prodUrl =
        'https://fluttershopapp-d31ee.firebaseio.com/userFavs/$userId/$id.json?auth=$token';
    try {
      final resp = await http.put(
        prodUrl,
        body: json.encode(
          isFav,
        ),
      );
      if (resp.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (_) {
      _setFavValue(oldStatus);
    }
  }
}
