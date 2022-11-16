import 'package:shop_app/models/branch.dart';
import 'package:shop_app/models/student.dart';
import 'package:shop_app/models/subject.dart';

class Class{
  String id;
  Subject subject;
  Branch branch;
  List<Student> students;

  Class(this.id,this.subject, this.branch, this.students);
}