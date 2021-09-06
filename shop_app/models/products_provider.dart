import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

import 'package:shop_app/models/product.dart';

class ProductsProvider with ChangeNotifier {
  static const url = 'https://fluttershopapp-d31ee.firebaseio.com/products';
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   desc: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   desc: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   desc: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   desc: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final String authToken;
  final String userId;

  ProductsProvider(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((prod) => prod.isFav).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => id == prod.id);
  }

  Future<void> fetchAndSetProds([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    try {
      final resp = await http.get(url + '.json?auth=$authToken$filterString');
      final data = json.decode(resp.body) as Map<String, dynamic>;
      if (data != null) {
        final favResp = await http.get(
            'https://fluttershopapp-d31ee.firebaseio.com/userFavs/$userId.json?auth=$authToken');
        final favData = json.decode(favResp.body);
        final List<Product> loadedProds = [];
        data.forEach((prodId, prodData) {
          loadedProds.add(Product(
            id: prodId,
            title: prodData['title'],
            desc: prodData['desc'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFav: favData == null ? false : favData[prodId] ?? false,
          ));
        });
        _items = loadedProds;
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product prod) async {
    try {
      final resp = await http.post(
        url + '.json?auth=$authToken',
        body: json.encode({
          'title': prod.title,
          'desc': prod.desc,
          'imageUrl': prod.imageUrl,
          'price': prod.price,
          'creatorId': userId,
        }),
      );
      final newProd = Product(
        title: prod.title,
        desc: prod.desc,
        imageUrl: prod.imageUrl,
        price: prod.price,
        id: json.decode(resp.body)['name'],
      );
      _items.insert(0, newProd);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product prod) async {
    final prodIdx = _items.indexWhere((prod) => prod.id == id);
    if (prodIdx >= 0) {
      final prodUrl = url + '/$id.json?auth=$authToken';
      await http.patch(prodUrl,
          body: json.encode({
            'title': prod.title,
            'desc': prod.desc,
            'imageUrl': prod.imageUrl,
            'price': prod.price,
          }));
      _items[prodIdx] = prod;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final prodUrl = url + '/$id.json?auth=$authToken';
    final existingProdIdx = _items.indexWhere((prod) => prod.id == id);
    var existingProd = _items[existingProdIdx];
    _items.removeAt(existingProdIdx);
    notifyListeners();
    final resp = await http.delete(prodUrl);
    if (resp.statusCode >= 400) {
      // Roll back if fails
      _items.insert(existingProdIdx, existingProd);
      notifyListeners();
      throw HttpException('Could not delete product.');
    } else {
      existingProd = null;
    }
  }
}
