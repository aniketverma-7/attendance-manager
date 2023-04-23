import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import '../models/subject.dart';

class Subjects with ChangeNotifier {
  Map<String,Subject> _subjects = {};


  Future<void> addSubject(String subjectCode, String subjectName) async {
    try {
      final Uri uri = Uri.parse(
          "https://attendance-manager-413cc-default-rtdb.firebaseio.com/subjects.json");

      final response = await http.post(uri,
          body: json.encode({
            'subjectCode': subjectCode,
            'subjectName': subjectName,
          }));
      final responseData = json.decode(response.body);
      if(responseData['error']!=null){
        throw HttpException(responseData['error']['message']);
      }
      _subjects[responseData['name']] = Subject(id: responseData['name'],subjectCode: subjectCode, subjectName: subjectName);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateSubject(String id, String subjectCode, String subjectName) async {
    try {
     final Uri uri = Uri.parse(
          "https://attendance-manager-413cc-default-rtdb.firebaseio.com/subjects/$id.json");

      await http.patch(uri,
          body: json.encode({
            'subjectCode': subjectCode,
            'subjectName': subjectName,
          }));
      _subjects[id] = Subject(id: id,subjectName: subjectName,subjectCode: subjectCode);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchSubjects() async {
    try {
      final url = Uri.parse('https://attendance-manager-413cc-default-rtdb.firebaseio.com/subjects.json');
      final response = await http.get(url);
      Map<String,Subject> loadedSubject = {};
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data!= null){
        data.forEach((subjectId, subjectData) {
          final code = subjectData['subjectCode'];
          final name = subjectData['subjectName'];
          final subject = Subject(id:subjectId,subjectCode: code, subjectName: name);
          loadedSubject[subjectId] = subject;
        });
        _subjects = loadedSubject;
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  List<Subject> get subjects{
    return _subjects.values.toList();
  }

  Future<void> removeSubject(String subjectId) async {
    try {

      final existingSubject = _subjects[subjectId];
      _subjects.remove(subjectId);
      notifyListeners();

      final Uri uri = Uri.parse(
          "https://attendance-manager-413cc-default-rtdb.firebaseio.com/subjects/$subjectId.json");
      final response = await http.delete(uri);
      if(response.statusCode>=400){
        _subjects[subjectId] = existingSubject!;
        notifyListeners();
        throw HttpException('Could not delete subject');
      }
    } catch (error) {
      rethrow;
    }
  }

}
