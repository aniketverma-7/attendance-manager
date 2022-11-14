import 'package:shop_app/models/student.dart';
import 'package:shop_app/models/subject.dart';

class Branch {
  final String id;
  final String name;
  final List<Student> students;
  final List<Subject> subjects;

  Branch({
    required this.id,
    required this.name,
    required this.students,
    required this.subjects,
  });
}
