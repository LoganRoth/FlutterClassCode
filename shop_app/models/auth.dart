import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    } else {
      return null;
    }
  }

  String get userId {
    return _userId;
  }

  Future<void> signup(String email, String pwd) async {
    return _authenticate(email, pwd, "signUp");
  }

  Future<void> login(String email, String pwd) async {
    return _authenticate(email, pwd, "signInWithPassword");
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    /* prefs.clear() // removes all data */
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final data =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(data['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = data['token'];
    _userId = data['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> _authenticate(String email, String pwd, String urlSeg) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSeg?key=AIzaSyDr4m8yekil2uHtU3hP8U7cZ0AE6qbG7uo";
    try {
      final resp = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': pwd,
            'returnSecureToken': true,
          },
        ),
      );
      final respData = json.decode(resp.body);
      if (respData['error'] != null) {
        throw HttpException(respData['error']['message']);
      } else {
        _token = respData['idToken'];
        _userId = respData['localId'];
        _expiryDate = DateTime.now()
            .add(Duration(seconds: int.parse(respData['expiresIn'])));
      }
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }
}
