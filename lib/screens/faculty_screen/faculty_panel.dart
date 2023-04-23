import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/student.dart';
import 'package:shop_app/models/subject.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/faculty_provider.dart';
import 'package:shop_app/screens/faculty_screen/attendance_screen.dart';
import 'package:shop_app/widgets/class_card.dart';
import 'package:shop_app/widgets/faculty_drawer.dart';

import '../../models/branch.dart';
import '../../models/class.dart';
import '../../models/faculty.dart';

class FacultyPanel extends StatefulWidget {
  static const String routeName = "/faculty-panel";

  @override
  State<FacultyPanel> createState() => _FacultyPanelState();
}

class _FacultyPanelState extends State<FacultyPanel> {
  var _isLoading = false;
  var _isInit = false;
  bool e = false;
  late final Faculty faculty;
  List<Subject> subjects = [];
  Map<Subject, List<Student>> subjectStudentMap = {};

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    // super.didChangeDependencies();
    // if (!_isInit) {
    //   final username = Provider.of<Auth>(context, listen: false).userName;
    //   setState(() {
    //     _isLoading = true;
    //   });
    //   Provider.of<Faculties>(context, listen: false)
    //       .fetchFacultyByUsername(username)
    //       .catchError((error) {
    //     e = true;
    //     showAlertDialog(error.toString());
    //   }).then((_) {
    //     if (!e) {
    //       faculty = Provider.of<Faculties>(context, listen: false).faculties[0];
    //       final classes = faculty.classes;
    //       if (classes != null) {
    //         classes.forEach((e) {
    //           List<Student> students = [];
    //           final branch = Branch(
    //             id: e['branch']['id'],
    //             name: e['branch']['name'],
    //           );
    //
    //           final subject = Subject(
    //             id: e['subject']['id'],
    //             subjectName: e['subject']['subjectName'],
    //             subjectCode: e['subject']['subjectCode'],
    //           );
    //
    //           final s = e['students'] as List<dynamic>;
    //           s.forEach((element) {
    //             final student = Student(
    //               id: element['id'],
    //               name: element['name'],
    //               enrollment: element['enrollment'],
    //               email: element['email'],
    //               branch: branch,
    //               year: element['year'],
    //             );
    //             students.add(student);
    //           });
    //           subjects.add(subject);
    //           subjectStudentMap[subject] = students;
    //         });
    //       }
    //     }
    //     setState(() {
    //       _isLoading = false;
    //     });
    //   });
    //   _isInit = true;
    // }
  }

  Future showAlertDialog(String title) {
    return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(title),
              content:
                  Text((title.contains('Server')) ? 'Try again later' : ''),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('Dismiss')),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty Panel'),
      ),
      drawer: FacultyDrawer(),
      body: (_isLoading)
          ? Center(
              child: (e)
                  ? const Text('Unable to fetch record')
                  : const CircularProgressIndicator(),
            )
          : Container(
              margin: const EdgeInsets.all(5),
              child: classesGrid,
            ),
    );
  }

  void onClick(Subject subject) {
    Navigator.of(context).pushNamed(
      AttendanceScreen.routeName,
      arguments: {
        'students': subjectStudentMap[subject],
        'subject': subject,
      },
    ).then((_){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Attendance Uploaded"),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(20),
          shape: const StadiumBorder(),
          action: SnackBarAction(
            label: 'Dismiss',
            disabledTextColor: Colors.white,
            textColor: Colors.blue,
            onPressed: () {
              //Do whatever you want
            },
          ),
        ),
      );
    });
  }

  Widget get classesGrid {
    return (subjects.isEmpty)
        ? const Center(
            child: Text('No classes assign to you yet.'),
          )
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1,
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 20,
            ),
            itemBuilder: (context, index) {
              return ClassCard(subjects[index], onClick);
            },
            itemCount: subjects.length,
          );
    // return Container();
  }
}
