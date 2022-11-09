import 'package:shop_app/models/subject.dart';

class Student {
  final String id;
  final String name;
  final String enrollment;
  final String email;
  final String branch;
  final String year;
  final List<Subject> subjects;

  Student({
    required this.id,
    required this.name,
    required this.enrollment,
    required this.email,
    required this.branch,
    required this.year,
    required this.subjects,
  });

  @override
  String toString() {
    return 'Student{id: $id, name: $name, enrollment: $enrollment, email: $email, branch: $branch, year: $year, subjects: $subjects}';
  }
}
