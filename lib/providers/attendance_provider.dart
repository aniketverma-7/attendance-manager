import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../models/attendance.dart';

class AttendanceProvider extends ChangeNotifier {
  Future<void> addAttendance(Attendance attendance) async {
    try {
      final Uri uri = Uri.parse(
          "https://attendance-manager-413cc-default-rtdb.firebaseio.com/attendance/${attendance.enrollment}.json");
      await http.post(uri,
            body: json.encode({
              'subject': attendance.subject.id,
              'status': attendance.status,
              'dateTime': attendance.dateTime.toString(),
            }));
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
