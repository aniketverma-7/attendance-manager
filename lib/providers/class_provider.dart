import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/branch.dart';

import '../models/class.dart';
import '../models/http_exception.dart';
import '../models/student.dart';
import '../models/subject.dart';

class Classes with ChangeNotifier {
  List<Class> _classes = [];


  Future<void> addClass(Subject subject, Branch branch, List<Student?> students) async {
    try {
      final Uri uri = Uri.parse(
          "https://attendance-manager-413cc-default-rtdb.firebaseio.com/classes.json");

      final response = await http.post(uri,
          body: json.encode({
            'subject': {
              'id':subject.id,
              'subjectName':subject.subjectName,
              'subjectCode':subject.subjectCode,
            },
            'branch': {
              'id':branch.id,
              'name':branch.name
            },
            'students':students.map((e){
              return {
                'name': e?.name,
                'email': e?.email,
                'enrollment': e?.enrollment,
                'branch': {
                  'id': e?.branch.id,
                  'name': e?.branch.name,
                },
                'year': e?.year,
              };
            }).toList()
          }));
      final responseData = json.decode(response.body);
      if(responseData['error']!=null){
        throw HttpException(responseData['error']['message']);
      }
      // _classes.add(Class(responseData['name'],subject, branch, students.toList()));
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  //TODO: incomplete method
  Future<void> updateClass(String id, String subjectCode, String subjectName) async {
    try {
      final index = _classes.indexWhere((element) => element.id == id);
      final Uri uri = Uri.parse(
          "https://attendance-manager-413cc-default-rtdb.firebaseio.com/classes/$id.json");

      await http.patch(uri,
          body: json.encode({
            'subjectCode': subjectCode,
            'subjectName': subjectName,
          }));
      // _subjects[index] = Subject(id: id,subjectName: subjectName,subjectCode: subjectCode);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchClasses() async {
    try {
      final url = Uri.parse('https://attendance-manager-413cc-default-rtdb.firebaseio.com/classes.json');
      final response = await http.get(url);
      List<Class> loadedClasses = [];
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data!= null){
        data.forEach((id, data) {
          final subject = data['subject'] as Subject;
          final branch = data['branch'] as Branch;
          final students = data['students'] as List<Student>;
          final class_ = Class(id, subject, branch, students);
          loadedClasses.add(class_);
        });
        _classes = loadedClasses;
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  List<Class> get classes{
    return [..._classes];
  }

  Future<void> removeClass(String classID) async {
    try {
      final index = _classes.indexWhere((element) => element.id == classID);
      final existingSubject = _classes[index];
      _classes.removeAt(index);
      notifyListeners();

      final Uri uri = Uri.parse(
          "https://attendance-manager-413cc-default-rtdb.firebaseio.com/classes/$classID.json");
      final response = await http.delete(uri);
      if(response.statusCode>=400){
        _classes.insert(index, existingSubject);
        notifyListeners();
        throw HttpException('Could not delete subject');
      }
    } catch (error) {
      rethrow;
    }
  }

}