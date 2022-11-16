import 'package:shop_app/models/student.dart';
import 'package:shop_app/models/subject.dart';

class Branch {
  final String id;
  final String name;

  Branch({
    required this.id,
    required this.name,
  });


  @override
  String toString() {
    return 'Branch{id: $id, name: $name}';
  }
}
