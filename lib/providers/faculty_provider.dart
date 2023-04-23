import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/branch.dart';
import 'package:shop_app/models/faculty.dart';
import 'package:shop_app/models/student.dart';

import '../models/class.dart';
import '../models/http_exception.dart';
import '../models/subject.dart';

class Faculties with ChangeNotifier {
  List<Faculty> _faculties = [];

  void addFaculty(
      String name, String email, List<Class> classes) async {
    // try {
    //   final username = email.substring(0, email.indexOf("@"));
    //   final Uri makeUser = Uri.parse(
    //       "https://attendance-manager-413cc-default-rtdb.firebaseio.com/credentials/$username.json");
    //
    //   final userAccountResponse = await http.put(makeUser,
    //       body: json.encode({"password": username, "tag": "FACULTY"}));
    //
    //   if (userAccountResponse.statusCode >= 400) {
    //     throw HttpException("Unable to create account for the faculty");
    //   }
    //   final Uri uri = Uri.parse(
    //       "https://attendance-manager-413cc-default-rtdb.firebaseio.com/faculty/$username.json");
    //   final response = await http.put(uri,
    //       body: json.encode({
    //         'name': name,
    //         'email': email,
    //         'username': username,
    //         'classes': classes.map((c) {
    //           return {
    //             'subject': {
    //               'id': c.subject.id,
    //               'subjectName': c.subject.subjectName,
    //               'subjectCode': c.subject.subjectCode,
    //             },
    //             'branch': {'id': c.branch.id, 'name': c.branch.name},
    //             'students': c.students.map((s) {
    //               return {
    //                 'id': s.id,
    //                 'name': s.name,
    //                 'email': s.email,
    //                 'enrollment': s.enrollment,
    //                 'branch': {
    //                   'id': s.branch.id,
    //                   'name': s.branch.name,
    //                 },
    //                 'year': s.year,
    //               };
    //             }).toList()
    //           };
    //         }).toList(),
    //       }));
    //   final responseData = json.decode(response.body);
    //   if (responseData['error'] != null) {
    //     throw HttpException(responseData['error']['message']);
    //   }
    //   // _faculties
    //   // .add(Faculty(id: responseData['name'], name: name, email: email));
    //   notifyListeners();
    // } catch (error) {
    //   rethrow;
    // }
   }

  Future<void> updateFaculty(
      String id, String name, String email, List<Class> classes) async {
    // try {
    //   final index = _faculties.indexWhere((element) => element.id == id);
    //   final Uri uri = Uri.parse(
    //       "https://attendance-manager-413cc-default-rtdb.firebaseio.com/faculty/$id.json");
    //
    //   await http.patch(uri,
    //       body: json.encode({
    //         'name': name,
    //         'email': email,
    //         'classes': classes.map((c) {
    //           return {
    //             'subject': {
    //               'id': c.subject.id,
    //               'subjectName': c.subject.subjectName,
    //               'subjectCode': c.subject.subjectCode,
    //             },
    //             'branch': {'id': c.branch.id, 'name': c.branch.name},
    //             'students': c.students.map((s) {
    //               return {
    //                 'id': s.id,
    //                 'name': s.name,
    //                 'email': s.email,
    //                 'enrollment': s.enrollment,
    //                 'branch': {
    //                   'id': s.branch.id,
    //                   'name': s.branch.name,
    //                 },
    //                 'year': s.year,
    //               };
    //             }).toList()
    //           };
    //         }).toList(),
    //       }));
    //   // _faculties[index] = Faculty(id: id, name: name, email: email);
    //   notifyListeners();
    // } catch (error) {
    //   rethrow;
    // }
  }

  Future<void> fetchFaculty() async {
    // try {
    //   final url = Uri.parse(
    //       'https://attendance-manager-413cc-default-rtdb.firebaseio.com/faculty.json');
    //   final response = await http.get(url);
    //   List<Faculty> loadedFaculty = [];
    //   final data = json.decode(response.body) as Map<String, dynamic>;
    //
    //   data.forEach((key, value) {
    //     final class_ = value['classes'] as List<dynamic>;
    //     final email = value['email'];
    //     final name = value['name'];
    //     final username = value['username'];
    //     class_.forEach((element) {
    //       final branch = Branch(
    //           id: element['branch']['id'], name: element['branch']['name']);
    //       final List<Student> students = [];
    //       final s = element['students'] as List<dynamic>;
    //       s.forEach((element) {
    //         students.add(
    //           Student(
    //               id: element['id'],
    //               name: element['name'],
    //               enrollment: element['enrollment'],
    //               email: element['email'],
    //               branch: branch,
    //               year: element['year']),
    //         );
    //       });
    //       final subject = Subject(
    //         id: element['subject']['id'],
    //         subjectCode: element['subject']['subjectCode'],
    //         subjectName: element['subject']['subjectName'],
    //       );
    //     });
    //
    //     loadedFaculty.add(Faculty(id: username, name: name, email: email, classes: class_));
    //   });
    //   // if (data != null) {
    //   //   data.forEach((facultyId, facultyData) {
    //   //     final name = facultyData['name'];
    //   //     final email = facultyData['email'];
    //   //     final username = facultyData['username'];
    //   //     final faculty = Faculty(id: facultyId, name: name, email: email, username: username);
    //   //     loadedFaculty.add(faculty);
    //   //   });
    //     _faculties = loadedFaculty;
    //     notifyListeners();
    //   // }
    // } catch (error) {
    //   rethrow;
    // }
  }

  Future<void> fetchFacultyByUsername(String username) async {
    try {
      print(username);
      final url = Uri.parse(
          'https://attendance-manager-413cc-default-rtdb.firebaseio.com/faculty/$username.json');
      final response = await http.get(url);
      List<Faculty> loadedFaculty = [];
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data != null) {
        final email = data['email'];
        final name = data['name'];
        final classes = data['classes'];
        loadedFaculty.add(Faculty(id: username, name: name, email: email, classes: classes));
        _faculties = loadedFaculty;
        notifyListeners();
      }
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  List<Faculty> get faculties {
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
      if (response.statusCode >= 400) {
        _faculties.insert(index, existingSubject);
        notifyListeners();
        throw HttpException('Could not delete faculty');
      }
    } catch (error) {
      rethrow;
    }
  }
}
