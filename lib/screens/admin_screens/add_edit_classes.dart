import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/branch.dart';
import 'package:shop_app/models/subject.dart';

import '../../models/student.dart';
import '../../providers/branch_provider.dart';
import '../../providers/class_provider.dart';
import '../../providers/student_provider.dart';
import '../../providers/subject_provider.dart';

class ClassScreen extends StatefulWidget {
  static const String routeName = "/add-edit-classes";

  @override
  State<ClassScreen> createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  var _isLoading = true;
  var _isInit = false;
  var error = false;

  final _formKey = GlobalKey<FormState>();

  final branchController = TextEditingController();
  final studentController = TextEditingController();
  final subjectController = TextEditingController();

  Branch selectedBranch = Branch(name: '', id: '');
  Subject selectedSubject = Subject(id: '', subjectCode: '', subjectName: '');

  List<Branch> branches = [];
  List<Subject> subjects = [];
  List<Student> students = [];

  int count = 0;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (!_isInit) {
      Provider.of<Branches>(context, listen: false)
          .fetchBranch()
          .catchError((error) {
        setState(() {
          error = true;
          count = 3;
        });
      }).then((_) {
        if (!error) {
          branches = Provider.of<Branches>(context, listen: false).branches;
          setState(() {
            _isLoading = false;
            count++;
          });
        }
      });

      Provider.of<Subjects>(context, listen: false)
          .fetchSubjects()
          .catchError((error) {
        setState(() {
          error = true;
          _isLoading = false;
        });
      }).then((_) {
        if (!error) {
          subjects = Provider.of<Subjects>(context, listen: false).subjects;
          setState(() {
            _isLoading = false;
            count++;
          });
        }
      });

      Provider.of<Students>(context, listen: false)
          .fetchStudent()
          .catchError((error) {
        setState(() {
          error = true;
          _isLoading = false;
        });
      }).then((_) {
        if (!error) {
          students = Provider.of<Students>(context, listen: false).students;
          setState(() {
            _isLoading = false;
            count++;
          });
        }
      });

      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Class'),
      ),
      body: (error)
          ? const Center(
              child: Text('Server error, try again later.'),
            )
          : (_isLoading && count == 3)
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : classForm,
    );
  }

  List<Student?> filterStudentByBranch() {
    return students.map((e) {
      if(e.branchID == selectedBranch.id){
       return e;
      }
    }).toList();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      List<Student?> filterStudent = filterStudentByBranch();
      Provider.of<Classes>(context, listen: false)
          .addClass(selectedSubject, selectedBranch, filterStudent)
          .catchError((error) {
        print(error);
      }).then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  Widget get classForm {
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
                      controller: subjectController,
                      readOnly: true,
                      validator: (value) {
                        if (selectedSubject.subjectName.isEmpty) {
                          return "Please select subject";
                        }
                        return null;
                      },
                      onTap: () {
                        showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                elevation: 10,
                                content: StatefulBuilder(
                                  builder: (context, setState) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: List<Widget>.generate(
                                          subjects.length, (int index) {
                                        return ListTile(
                                          title:
                                              Text(subjects[index].subjectName),
                                          leading: Radio<Subject>(
                                            value: subjects[index],
                                            groupValue: selectedSubject,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedSubject = value!;
                                                subjectController.text =
                                                    selectedSubject.subjectName;
                                              });
                                            },
                                          ),
                                        );
                                      }),
                                    );
                                  },
                                ),
                              );
                            });
                      },
                      decoration: const InputDecoration(
                          labelText: 'Class Subject',
                          border: OutlineInputBorder()),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: branchController,
                      validator: (value) {
                        if (selectedBranch.name.isEmpty) {
                          return "Please select class branch";
                        }
                        return null;
                      },
                      readOnly: true,
                      onTap: () {
                        showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                elevation: 10,
                                content: StatefulBuilder(
                                  builder: (context, setState) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: List<Widget>.generate(
                                          branches.length, (int index) {
                                        return ListTile(
                                          title: Text(branches[index].name),
                                          leading: Radio<Branch>(
                                            value: branches[index],
                                            groupValue: selectedBranch,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedBranch = value!;
                                                branchController.text =
                                                    selectedBranch.name;
                                              });
                                            },
                                          ),
                                        );
                                      }),
                                    );
                                  },
                                ),
                              );
                            });
                      },
                      decoration: const InputDecoration(
                          labelText: 'Class Branch',
                          border: OutlineInputBorder()),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveForm,
                      child: const Text("Submit"),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
