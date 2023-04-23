import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import '../models/student.dart';

class Students with ChangeNotifier {
  List<Student> _students = [];

  Future<void> addStudent(
    String name,
    String enrollment,
    String email,
    String branchID,
    String year,
  ) async {
    try {
      final Uri uri = Uri.parse(
          "https://attendance-manager-413cc-default-rtdb.firebaseio.com/students/$enrollment.json");

      final response = await http.post(uri,
          body: json.encode({
            'name': name,
            'email': email,
            'enrollment': enrollment,
            'branch': branchID,
            'year': year,
          }));

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _students.add(Student(
        name: name,
        email: email,
        enrollment: enrollment,
        branchID: branchID,
        year: year,
      ));

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateStudent(
    String name,
    String enrollment,
    String email,
    String branchID,
    String year,
  ) async {
    try {
      final index = _students.indexWhere((element) => element.enrollment == enrollment);

      final Uri uri = Uri.parse(
          "https://attendance-manager-413cc-default-rtdb.firebaseio.com/students/$enrollment.json");

      await http.patch(uri,
          body: json.encode({
            'name': name,
            'email': email,
            'enrollment': enrollment,
            'branch': branchID,
            'year': year,
          }));

      _students[index] = Student(
        name: name,
        email: email,
        enrollment: enrollment,
        branchID: branchID,
        year: year,
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  //TODO: Change this
  Future<void> fetchStudent() async {
    try {
      final url = Uri.parse(
          'https://attendance-manager-413cc-default-rtdb.firebaseio.com/students.json');
      final response = await http.get(url);
      List<Student> loadedStudent = [];
      final data = json.decode(response.body) as Map<String, dynamic>;
      data.forEach((enrollment, studentData) {

        final branchID = studentData['branch'];
        final email = studentData['email'];
        final enrollment = studentData['enrollment'];
        final name = studentData['name'];
        final year = studentData['year'];

        final student = Student(
          name: name,
          email: email,
          enrollment: enrollment,
          branchID: branchID,
          year: year,
        );
        loadedStudent.add(student);
      });
      _students = loadedStudent;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  List<Student> get students {
    return [..._students];
  }

  //TODO: Change this
  Future<void> removeStudent(String enrollment) async {
  //   try {
  //     final index = _students.indexWhere((element) => element.id == enrollment);
  //     final existingSubject = _students[index];
  //     _students.removeAt(index);
  //     notifyListeners();
  //
  //     final Uri uri = Uri.parse(
  //         "https://attendance-manager-413cc-default-rtdb.firebaseio.com/students/$enrollment.json");
  //     final response = await http.delete(uri);
  //     if (response.statusCode >= 400) {
  //       _students.insert(index, existingSubject);
  //       notifyListeners();
  //       throw HttpException('Could not delete student record');
  //     }
  //   } catch (error) {
  //     rethrow;
  //   }
  }
}
