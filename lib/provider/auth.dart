import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:shopappapp/models/http_exciption.dart';
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
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/$urlSegment?key=AIzaSyACHQY8agh7SVKujzm8Hm3m8rt28HkkIw8';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseDate = json.decode(response.body);
      if (responseDate['error'] != null) {
        throw HttpException(responseDate['error']['message']);
      }
      _token = responseDate['idToken'];
      _userId = responseDate['localId'];
      _expiryDate = DateTime.now().add(Duration(
        seconds: int.parse(responseDate['expiresIn']),
      ));
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
    }
    catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    //url='https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyACHQY8agh7SVKujzm8Hm3m8rt28HkkIw8';
    return _authenticate(email, password, 'accounts:signUp');
  }

  Future<void> logIn(String email, String password) async {
    // const url = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyACHQY8agh7SVKujzm8Hm3m8rt28HkkIw8';
    return _authenticate(email, password, 'accounts:signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
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
    // prefs.remove('userData');
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
