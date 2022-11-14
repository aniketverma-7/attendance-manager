import 'package:shop_app/models/faculty.dart';
import 'package:shop_app/models/student.dart';

class Department
{
  final String name;
  final List<Student> students;
  final List<Faculty> faculty;

  Department(this.name, this.students, this.faculty);
}