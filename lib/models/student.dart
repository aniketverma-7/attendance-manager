import 'package:shop_app/models/subject.dart';

import 'branch.dart';

class Student {
  final String id;
  final String name;
  final String enrollment;
  final String email;
  final Branch branch;
  final String year;

  Student({
    required this.id,
    required this.name,
    required this.enrollment,
    required this.email,
    required this.branch,
    required this.year,
  });



  @override
  String toString() {
    return 'Student{id: $id, name: $name, enrollment: $enrollment, email: $email, branch: $branch, year: $year}';
  }
}
