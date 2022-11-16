import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/branch.dart';

import '../../models/student.dart';
import '../../providers/branch_provider.dart';
import '../../providers/student_provider.dart';

class StudentScreen extends StatefulWidget {
  static const routeName = '/add-edit-student';

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  var _isLoading = true;
  var _isInit = false;
  final _formKey = GlobalKey<FormState>();
  List? subjectList;
  Branch selectedBranch = Branch(name: '', id: '');
  final branchController = TextEditingController();

  var _student = Student(
    id: '',
    name: '',
    email: '',
    enrollment: '',
    branch: Branch(name: '', id: ''),
    year: '',
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
      var provider = Provider.of<Branches>(context, listen: false);
      if (provider.branches.isEmpty) {
        provider.fetchBranch().catchError((error) {
          //TODO: Show alert dialog;
        }).then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      }else{
        branchController.text = _student.branch.name;
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    branchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              (_student.id.isNotEmpty) ? 'Update Student' : 'Add Students'),
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
        afterFuture(
          Provider.of<Students>(context, listen: false).updateStudent(
            _student.id,
            _student.name,
            _student.enrollment,
            _student.email,
            _student.branch,
            _student.year,),
          'Student record updated successfully',
        );
      } else {
        afterFuture(
          Provider.of<Students>(context, listen: false)
              .addStudent(
            _student.name,
            _student.enrollment,
            _student.email,
            _student.branch,
            _student.year,
          ),
          'Student record added successfully',
        );
      }
    }
  }


  void afterFuture(future, title) {
    bool error = false;
    future = future as Future<void>;
    future.catchError((error) {
      print(error);
      error = true;
      return showAlertDialog('Server error :(');
    }).then((_) {
      setState(() {
        _isLoading = false;
      });
    }).then((_){
      if(!error){
        return showAlertDialog(title);
      }
    });
  }

  Future showAlertDialog(String title) {
    return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(title),
          content: Text((title.contains('Server'))?'Try again later':''),
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

  Widget get studentForm {
    List<Branch> branches =
        Provider.of<Branches>(context, listen: false).branches;

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
                      );
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: branchController,
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
                                              branchController.text = selectedBranch.name;
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
                        labelText: 'Student Branch',
                        border: OutlineInputBorder()),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      return null;
                    },
                    onSaved: (value) {
                      _student = Student(
                        id: _student.id,
                        name: _student.name,
                        email: _student.email,
                        enrollment: _student.enrollment,
                        branch: selectedBranch,
                        year: _student.year,
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
