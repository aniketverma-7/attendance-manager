import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/branch.dart';
import '../models/http_exception.dart';
import '../models/subject.dart';

class Branches with ChangeNotifier {
  List<Branch> _branches = [];

  Future<void> addBranch(String name) async {
    try {
      final Uri uri = Uri.parse(
          "https://attendance-manager-413cc-default-rtdb.firebaseio.com/branches.json");

      final response = await http.post(uri,
          body: json.encode({
            'name': name,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _branches.add(Branch(id: responseData['name'], name: name));
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateBranch(String id, String name) async {
    try {
      final index = _branches.indexWhere((element) => element.id == id);
      final Uri uri = Uri.parse(
          "https://attendance-manager-413cc-default-rtdb.firebaseio.com/branches/$id.json");

      await http.patch(uri,
          body: json.encode({
            'name': name,
          }));
      _branches[index] = Branch(id: id, name: name);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchBranch() async {
    try {
      final url = Uri.parse(
          'https://attendance-manager-413cc-default-rtdb.firebaseio.com/branches.json');
      final response = await http.get(url);
      List<Branch> loadedBranch = [];
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data != null) {
        data.forEach((id, data) {
          final name = data['name'];
          final branch = Branch(id: id, name:name);
          loadedBranch.add(branch);
        });
        _branches = loadedBranch;
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  List<Branch> get branches {
    return [..._branches];
  }

  Future<void> removeBranch(String id) async {
    try {
      final index = _branches.indexWhere((element) => element.id == id);
      final existingSubject = _branches[index];
      _branches.removeAt(index);
      notifyListeners();

      final Uri uri = Uri.parse(
          "https://attendance-manager-413cc-default-rtdb.firebaseio.com/branches/$id.json");
      final response = await http.delete(uri);
      if (response.statusCode >= 400) {
        _branches.insert(index, existingSubject);
        notifyListeners();
        throw HttpException('Could not delete branch');
      }
    } catch (error) {
      rethrow;
    }
  }
}
