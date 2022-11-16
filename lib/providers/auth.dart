import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _id='';
  String _userName='';
  String _password='';
  String tag='';


  Future<void> loginUser(String username) async {
    try {
      final Uri uri = Uri.parse(
          "https://attendance-manager-413cc-default-rtdb.firebaseio.com/credentials/$username.json");

      final response = await http.get(uri);
      var responseData = json.decode(response.body);
      if(responseData == null){
        throw HttpException("User name not exist.");
      }
      else if(responseData['error']!=null){
        throw HttpException(responseData['error']['message']);
      }

      responseData = responseData as Map<String, dynamic>;
      var keys = responseData.keys;
      var value = responseData.values.first as Map<String,dynamic>;
      var list = value.values.toList();

      _id = keys.first;
      _userName = username;
      tag = list[1].toString();
      _password = list[0].toString();
    } catch (error) {
      rethrow;
    }
  }

  bool verifyCredentials(String password){
    return password==_password;
  }


}
