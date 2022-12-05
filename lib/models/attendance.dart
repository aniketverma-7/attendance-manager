import 'package:shop_app/models/class.dart';
import 'package:shop_app/models/subject.dart';

class Attendance
{
  String enrollment;
  Subject subject;
  bool status;
  DateTime dateTime;

  Attendance(this.enrollment, this.subject, this.status, this.dateTime);
}