import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../models/attendance.dart';

class AttendanceProvider extends ChangeNotifier {
  Future<void> addAttendance(Attendance attendance) async {
    try {
      final Uri uri = Uri.parse(
          "https://attendance-manager-413cc-default-rtdb.firebaseio.com/attendance.json");
      await http.post(uri,
            body: json.encode({
              'enrollment': attendance.enrollment,
              'subject': {
                'id': attendance.subject.id,
                'subjectName': attendance.subject.subjectName,
                'subjectCode': attendance.subject.subjectCode,
              },
              'status': attendance.status,
              'dateTime': attendance.dateTime.toString(),
            }));
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
