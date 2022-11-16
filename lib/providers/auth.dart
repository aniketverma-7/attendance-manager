import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String userName = '';
  String _password = '';
  String tag = '';

  Future<void> loginUser(String username) async {
    try {
      final Uri uri = Uri.parse(
          "https://attendance-manager-413cc-default-rtdb.firebaseio.com/credentials/$username.json");

      final response = await http.get(uri);
      var responseData = json.decode(response.body);
      if (responseData == null) {
        throw HttpException("User name not exist.");
      } else if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _password = responseData['password'];
      tag = responseData['tag'];
      userName = username;
    } catch (error) {
      rethrow;
    }
  }

  bool verifyCredentials(String password) {
    return password == _password;
  }

  Future<void> changePassword(String newPassword) async {
    try {
      if (newPassword == _password) {
        throw HttpException("new password cannot be same as old password");
      }

      final Uri uri = Uri.parse(
          "https://attendance-manager-413cc-default-rtdb.firebaseio.com/credentials/$userName.json");

      final response = await http.put(uri,
          body: json.encode({'password': newPassword, 'tag': tag}));

      if (response.statusCode >= 400) {
        throw HttpException("unable to update password at the moment");
      }
      _password = newPassword;
    } catch (error) {
      rethrow;
    }
  }
}
