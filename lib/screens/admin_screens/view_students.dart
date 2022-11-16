import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/student_provider.dart';
import 'package:shop_app/widgets/view_student_card.dart';
import 'package:shop_app/widgets/view_subject_card.dart';

import '../../models/student.dart';

class ViewStudents extends StatefulWidget {
  static const routeName = '/view-student';

  @override
  State<ViewStudents> createState() => _ViewStudentsState();
}

class _ViewStudentsState extends State<ViewStudents> {
  var _isLoading = true;
  var _isInit = false;
  String message = "";
  List<Student> students = [];

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    if (!_isInit) {
      Provider.of<Students>(context, listen: false)
          .fetchStudent()
          .catchError((error) {
        print(error);
        setState(() {
          message = "Server Error, unable to fetch right now";
        });
      }).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (message.isEmpty) {
      students = Provider.of<Students>(context).students;
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('View Students'),
        ),
        body: (_isLoading)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : buildListView(students));
  }

  Widget buildListView(students) {
    return (students.length > 0)
        ? ListView.builder(
            itemBuilder: (ctx, index) => StudentCard(students[index]),
            itemCount: students.length,
          )
        : Center(
            child: Text(message.isNotEmpty
                ? message
                : "No student added in the department at the moment"),
          );
  }
}

// (!_isInit)
// ? const Center(child: CircularProgressIndicator())
// : (subjects.isEmpty)
// ? const Center(
// child: Text('No Subjects added at the moment'),
// )
// : buildListView(subjects),
