import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import '../models/student.dart';
import '../models/subject.dart';

class Students with ChangeNotifier {
  List<Student> _students = [];

  Future<void> addStudent(
    String name,
    String enrollment,
    String email,
    String branch,
    String year,
    List<Subject> subjects,
  ) async {
    try {
      final Uri uri = Uri.parse(
          "https://attendance-manager-413cc-default-rtdb.firebaseio.com/students.json");

      final response = await http.post(uri,
          body: json.encode({
            'name': name,
            'email': email,
            'enrollment': enrollment,
            'branch': branch,
            'year': year,
            'subjects': subjects
                .map((subject) => {
                      'id': subject.id,
                      'subjectName': subject.subjectName,
                      'subjectCode': subject.subjectCode,
                    })
                .toList()
          }));

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _students.add(Student(
        id: responseData['name'],
        name: name,
        email: email,
        enrollment: enrollment,
        branch: branch,
        year: year,
        subjects: subjects,
      ));
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateSubject(
    String id,
    String name,
    String enrollment,
    String email,
    String branch,
    String year,
    List<Subject> subjects,
  ) async {
    try {
      final index = _students.indexWhere((element) => element.id == id);

      final Uri uri = Uri.parse(
          "https://attendance-manager-413cc-default-rtdb.firebaseio.com/student/$id.json");

      await http.patch(uri,
          body: json.encode({
            'name': name,
            'email': email,
            'enrollment': enrollment,
            'branch': branch,
            'year': year,
            'subjects': subjects
          }));

      _students[index] = Student(
        id: id,
        name: name,
        email: email,
        enrollment: enrollment,
        branch: branch,
        year: year,
        subjects: subjects,
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchSubjects() async {
    try {
      final url = Uri.parse(
          'https://attendance-manager-413cc-default-rtdb.firebaseio.com/subjects.json');
      final response = await http.get(url);
      List<Student> loadedStudent = [];
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data != null) {
        data.forEach((studentId, studentData) {
          final name = studentData['name'];
          final enrollment = studentData['enrollment'];
          final email = studentData['email'];
          final branch = studentData['branch'];
          final year = studentData['year'];
          final subjects = studentData['subjects'];
          final student = Student(
            id: studentData['name'],
            name: name,
            email: email,
            enrollment: enrollment,
            branch: branch,
            year: year,
            subjects: subjects,
          );
          loadedStudent.add(student);
        });
        _students = loadedStudent;
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  List<Student> get students {
    return [..._students];
  }

  Future<void> removeStudent(String subjectId) async {
    try {
      final index = _students.indexWhere((element) => element.id == subjectId);
      final existingSubject = _students[index];
      _students.removeAt(index);
      notifyListeners();

      final Uri uri = Uri.parse(
          "https://attendance-manager-413cc-default-rtdb.firebaseio.com/subjects/$subjectId.json");
      final response = await http.delete(uri);
      if (response.statusCode >= 400) {
        _students.insert(index, existingSubject);
        notifyListeners();
        throw HttpException('Could not delete student record');
      }
    } catch (error) {
      rethrow;
    }
  }
}
