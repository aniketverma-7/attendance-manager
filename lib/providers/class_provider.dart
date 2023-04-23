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

  Future<void> addClass(
      Subject subject, Branch branch, List<Student?> students) async {
    try {
      final Uri uri = Uri.parse(
          "https://attendance-manager-413cc-default-rtdb.firebaseio.com/classes.json");

      final response = await http.post(uri,
          body: json.encode({
            'subject': subject.id,
            'branch': branch.id,
            'students': students.map((e) {
              return {
                'enrollment': e?.enrollment,
              };
            }).toList()
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      // _classes.add(Class(responseData['name'],subject, branch, students.toList()));
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  //TODO: incomplete method
  Future<void> updateClass(
      String id, String subjectCode, String subjectName) async {
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
      final url = Uri.parse(
          'https://attendance-manager-413cc-default-rtdb.firebaseio.com/classes.json');
      final response = await http.get(url);
      List<Class> loadedClasses = [];
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data != null) {
        data.forEach((id, data) {
          final subjectID = data['subject'];
          final branchID = data['branch'];
          final students = data['students'] as List<dynamic>;

          List<Student> s = [];
          print("$subjectID $branchID ${students}");
          // students.forEach((student) {
          //   s.add(
          //     Student(
          //       name: student['name'],
          //       enrollment: student['enrollment'],
          //       email: student['email'],
          //       branchID: student['branch']['id'],
          //       year: student['year'],
          //     ),
          //   );
          // });

          // final class_ = Class(
          //     id,
          //     Subject(
          //       id: subject['id'],
          //       subjectCode: subject['subjectCode'],
          //       subjectName: subject['subjectName'],
          //     ),
          //     Branch(
          //       id: branch['id'],
          //       name: branch['name'],
          //     ),
          //     s);
          // loadedClasses.add(class_);
        });
        _classes = loadedClasses;
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  List<Class> get classes {
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
      if (response.statusCode >= 400) {
        _classes.insert(index, existingSubject);
        notifyListeners();
        throw HttpException('Could not delete subject');
      }
    } catch (error) {
      rethrow;
    }
  }
}
