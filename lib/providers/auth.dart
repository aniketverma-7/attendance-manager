import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  static const String _apiKey = "AIzaSyAfWY_vEEek-qWirTitZgqSPvIhippz1L4";
  static const String _baseUrl =
      "https://www.googleapis.com/identitytoolkit/v3/relyingparty/";
  final Uri _signUpUrl = Uri.parse("${_baseUrl}signupNewUser?key=$_apiKey");
  final Uri _loginUrl = Uri.parse("${_baseUrl}verifyPassword?key=$_apiKey");

  Future<void> _authenticate(String email, String password, Uri uri) async {
    try {
      final response = await http.post(uri,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, _signUpUrl);
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, _loginUrl);
  }

  bool get isAuth{
    return token!=null;
  }

  String? get userId{
    return _userId;
  }

  String? get token{
    if(_expiryDate != null && _expiryDate!.isAfter(DateTime.now()) && _token != null) {
      return _token;
    }
    return null;
  }

}
