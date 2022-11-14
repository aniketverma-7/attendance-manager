import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/faculty.dart';

import '../models/http_exception.dart';
import '../models/subject.dart';

class Faculties with ChangeNotifier {
  List<Faculty> _faculties = [];


  Future<void> addFaculty(String name, String email) async {
    try {
      final Uri uri = Uri.parse(
          "https://attendance-manager-413cc-default-rtdb.firebaseio.com/faculty.json");

      final response = await http.post(uri,
          body: json.encode({
            'name': name,
            'email': email,
          }));
      final responseData = json.decode(response.body);
      if(responseData['error']!=null){
        throw HttpException(responseData['error']['message']);
      }
      _faculties.add(Faculty(id: responseData['name'],name: name, email: email));
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateFaculty(String id, String name, String email) async {
    try {
      final index = _faculties.indexWhere((element) => element.id == id);
      final Uri uri = Uri.parse(
          "https://attendance-manager-413cc-default-rtdb.firebaseio.com/faculty/$id.json");

      await http.patch(uri,
          body: json.encode({
            'name': name,
            'email': email,
          }));
      _faculties[index] = Faculty(id: id,name: name, email: email);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchFaculty() async {
    try {
      final url = Uri.parse('https://attendance-manager-413cc-default-rtdb.firebaseio.com/faculty.json');
      final response = await http.get(url);
      List<Faculty> loadedFaculty = [];
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data!= null){
        data.forEach((facultyId, facultyData) {
          final name = facultyData['name'];
          final email = facultyData['email'];
          final faculty = Faculty(id:facultyId,name: name, email: email);
          loadedFaculty.add(faculty);
        });
        _faculties = loadedFaculty;
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  List<Faculty> get faculties{
    return [..._faculties];
  }

  Future<void> removeFaculty(String facultyId) async {
    try {
      final index = _faculties.indexWhere((element) => element.id == facultyId);
      final existingSubject = _faculties[index];
      _faculties.removeAt(index);
      notifyListeners();

      final Uri uri = Uri.parse(
          "https://attendance-manager-413cc-default-rtdb.firebaseio.com/faculty/$facultyId.json");
      final response = await http.delete(uri);
      if(response.statusCode>=400){
        _faculties.insert(index, existingSubject);
        notifyListeners();
        throw HttpException('Could not delete faculty');
      }
    } catch (error) {
      rethrow;
    }
  }

}
