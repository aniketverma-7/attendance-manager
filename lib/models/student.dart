import 'package:shop_app/models/subject.dart';

import 'branch.dart';

class Student {
  final String name;
  final String enrollment;
  final String email;
  final String branchID;
  final String year;

  Student({
    required this.name,
    required this.enrollment,
    required this.email,
    required this.branchID,
    required this.year,
  });



  @override
  String toString() {
    return 'Student{name: $name, enrollment: $enrollment, email: $email, branch: $branchID, year: $year}';
  }
}
