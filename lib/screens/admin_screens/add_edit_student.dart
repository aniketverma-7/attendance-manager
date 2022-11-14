import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:provider/provider.dart';

import '../../models/student.dart';
import '../../models/subject.dart';
import '../../providers/student_provider.dart';
import '../../providers/subject_provider.dart';

class StudentScreen extends StatefulWidget {
  static const routeName = '/add-edit-student';

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  var _isLoading = false;
  var _isInit = false;
  final _formKey = GlobalKey<FormState>();
  List? subjectList;

  var _student = Student(
    id: '',
    name: '',
    email: '',
    enrollment: '',
    branch: '',
    year: '',
    subjects: [],
  );

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (!_isInit) {
      final student = ModalRoute.of(context)!.settings.arguments;
      subjectList = [];
      if (student != null) {
        _student = student as Student;
        _isInit = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text((_student.id.isNotEmpty)?'Update Student':'Add Students'),
        ),
        body: (_isLoading)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : studentForm);
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      if (_student.id.isNotEmpty) {
        _updateStudent();
      } else {
        _addStudent();
      }
    }
  }

  void _updateStudent() {
    bool e = false;
    Provider.of<Students>(context, listen: false).updateStudent(
        _student.id,
        _student.name,
        _student.enrollment,
        _student.email,
        _student.branch,
        _student.year,
        _student.subjects)
        .catchError((error) {
          print(error);
      return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Error while updating student'),
            content: const Text('Try again later'),
            actions: [
              FlatButton(
                  onPressed: () {
                    e = true;
                    Navigator.of(ctx).pop();
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('Dismiss')),
            ],
          ));
    }).then((_) {
       if(!e){
         return showDialog(
             context: context,
             builder: (ctx) => AlertDialog(
               title: const Text('Student Record Updated'),
               actions: [
                 FlatButton(
                     onPressed: () {
                       Navigator.of(ctx).pop();
                       Navigator.of(ctx).pop();
                     },
                     child: const Text('Dismiss')),
               ],
             ));
       }
    });
  }

  void _addStudent() {
    bool e = false;
    Provider.of<Students>(context, listen: false)
        .addStudent(
      _student.name,
      _student.enrollment,
      _student.email,
      _student.branch,
      _student.year,
      _student.subjects,
    )
        .catchError((error) {
      e = true;
      print("Error in save form: " + error);
      return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Error while adding student record'),
                content: const Text('Try again later'),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        Navigator.of(ctx).pop();
                      },
                      child: const Text('Dismiss')),
                ],
              ));
    }).then((_) {
      if (!e) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text('Student Added'),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          Navigator.of(ctx).pop();
                        },
                        child: const Text('Dismiss')),
                  ],
                ));
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  Widget get studentForm {
    List<Subject> subjects =
        Provider.of<Subjects>(context, listen: false).subjects;

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Student Name',
                        border: OutlineInputBorder()),
                    textInputAction: TextInputAction.next,
                    initialValue: _student.name,
                    onFieldSubmitted: (_) {},
                    validator: (value) {
                      return null;
                    },
                    onSaved: (value) {
                      _student = Student(
                        id: _student.id,
                        name: value.toString(),
                        email: _student.email,
                        enrollment: _student.enrollment,
                        branch: _student.branch,
                        year: _student.year,
                        subjects: _student.subjects,
                      );
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Student Enrollment',
                        border: OutlineInputBorder()),
                    textInputAction: TextInputAction.next,
                    initialValue: _student.enrollment,
                    onFieldSubmitted: (_) {},
                    validator: (value) {
                      return null;
                    },
                    onSaved: (value) {
                      _student = Student(
                        id: _student.id,
                        name: _student.name,
                        email: _student.email,
                        enrollment: value.toString(),
                        branch: _student.branch,
                        year: _student.year,
                        subjects: _student.subjects,
                      );
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Student Email',
                        border: OutlineInputBorder()),
                    textInputAction: TextInputAction.next,
                    initialValue: _student.email,
                    onFieldSubmitted: (_) {},
                    validator: (value) {
                      return null;
                    },
                    onSaved: (value) {
                      _student = Student(
                        id: _student.id,
                        name: _student.name,
                        email: value.toString(),
                        enrollment: _student.enrollment,
                        branch: _student.branch,
                        year: _student.year,
                        subjects: _student.subjects,
                      );
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Student Branch',
                        border: OutlineInputBorder()),
                    textInputAction: TextInputAction.next,
                    initialValue: _student.branch,
                    onFieldSubmitted: (_) {},
                    validator: (value) {
                      return null;
                    },
                    onSaved: (value) {
                      _student = Student(
                        id: _student.id,
                        name: _student.name,
                        email: _student.email,
                        enrollment: _student.enrollment,
                        branch: value.toString(),
                        year: _student.year,
                        subjects: _student.subjects,
                      );
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: 'Student Year',
                        border: OutlineInputBorder()),
                    textInputAction: TextInputAction.next,
                    initialValue: _student.year,
                    onFieldSubmitted: (_) {},
                    validator: (value) {
                      return null;
                    },
                    onSaved: (value) {
                      _student = Student(
                        id: _student.id,
                        name: _student.name,
                        email: _student.email,
                        enrollment: _student.enrollment,
                        branch: _student.branch,
                        year: value.toString(),
                        subjects: _student.subjects,
                      );
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: MultiSelectFormField(
                    autovalidate: AutovalidateMode.disabled,
                    title: const Text('Subjects'),
                    dialogShapeBorder: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0))),
                    dataSource: [
                      ...subjects.map((e) {
                        return {"display": e.subjectName, "value": e};
                      }).toList()
                    ],
                    textField: 'display',
                    valueField: 'value',
                    okButtonLabel: 'OK',
                    cancelButtonLabel: 'CANCEL',
                    border: const OutlineInputBorder(),
                    initialValue: subjectList,
                    onSaved: (value) {
                      if (value == null) return;
                      subjectList = value;
                      List<Subject> subjects = [];
                      subjectList?.asMap().forEach((key, value) {
                        subjects.add(value);
                      });
                      _student = Student(
                        id: _student.id,
                        name: _student.name,
                        email: _student.email,
                        enrollment: _student.enrollment,
                        branch: _student.branch,
                        year: _student.year,
                        subjects: subjects,
                      );
                    },
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveForm,
                    child: const Text("Submit"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
