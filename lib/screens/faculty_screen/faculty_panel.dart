import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/student.dart';
import 'package:shop_app/models/subject.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/faculty_provider.dart';
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

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (!_isInit) {
      final username = Provider.of<Auth>(context, listen: false).userName;
      setState(() {
        _isLoading = true;
      });
      Provider.of<Faculties>(context, listen: false)
          .fetchFacultyByUsername(username)
          .catchError((error) {
        e = true;
        showAlertDialog(error.toString());
      }).then((_) {
        if (!e) {
          faculty = Provider.of<Faculties>(context, listen: false).faculties[0];
          // print(faculty.classes);
          final classes = faculty.classes;
          print(classes != null);
          if (classes != null) {
            classes.forEach((e) {
              final branch = Branch(
                id: e['branch']['id'],
                name: e['branch']['name'],
              );

              final subject = Subject(
                id: e['subject']['id'],
                subjectName: e['subject']['subjectName'],
                subjectCode: e['subject']['subjectCode'],
              );

              subjects.add(subject);
            });
            //   classes.map((e) {
            //   print(e);
            //   final branch = Branch(
            //     id: e['branch']['id'], name: e['branch']['name'],);
            //
            //   final subject = Subject(id: e['subject']['id'],
            //     subjectName: e['subject']['subjectName'],
            //     subjectCode: e['subject']['subjectCode'],);
            //   classes.add(Class(subject.subjectCode, subject, branch, []));
            // });
          }
        }
        setState(() {
          _isLoading = false;
        });
      });
      _isInit = true;
    }
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

  Widget get classesGrid {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 1,
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 20,
      ),
      itemBuilder: (context, index) {
        return ClassCard(subjects[index]);
      },
      itemCount: subjects.length,
    );
    // return Container();
  }
}
