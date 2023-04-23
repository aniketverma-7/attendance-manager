import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/faculty.dart';
import 'package:shop_app/providers/class_provider.dart';
import 'package:shop_app/providers/faculty_provider.dart';

import '../../models/class.dart';
import '../../providers/student_provider.dart';
import '../../providers/subject_provider.dart';

class FacultyScreen extends StatefulWidget {
  static const routeName = '/add-faculty';

  @override
  State<FacultyScreen> createState() => _FacultyScreenState();
}

class _FacultyScreenState extends State<FacultyScreen> {
  final _formKey = GlobalKey<FormState>();

  var _isLoading = false;
  var _isInit = false;
  List<Class> loadedClasses = [];

  List<Class> classList = [];

  var _faculty = Faculty(
    id: "",
    name: "",
    email: "",
    classes: [],
  );

  /**
   * TODO: student and subject data is fetched, batch them and then assign classes to the faculty.
   */
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (!_isInit) {
      bool err = false;
      var subjectProvider = Provider.of<Subjects>(context, listen: false);
      var provider = Provider.of<Classes>(context, listen: false);
      var studentProvider = Provider.of<Students>(context, listen: false);

      studentProvider.fetchStudent().catchError((error) {
        err = true;
      }).then((_) {
        if (!err) {
          subjectProvider.fetchSubjects().catchError((error) {
            err = true;
          }).then((_) {
            if (!err) {
              provider.fetchClasses().catchError((error) {
                err = true;
              }).then((_) {
                if (!err) {
                  loadedClasses = provider.classes;
                }
              });
            }
          });
        }
        setState(() {
          _isLoading = false;
        });
      });

      final faculty = ModalRoute.of(context)!.settings.arguments;
      if (faculty != null) {
        _faculty = faculty as Faculty;
        _isInit = true;
      }
    }
  }

  void _saveForm() {
    // if (_formKey.currentState!.validate()) {
    //   _formKey.currentState!.save();
    //   setState(() {
    //     _isLoading = true;
    //   });
    //   if (_faculty.id.isNotEmpty) {
    //     afterFuture(
    //         Provider.of<Faculties>(context, listen: false)
    //             .updateFaculty(_faculty.id, _faculty.name, _faculty.email, classList),
    //         'Faculty record updated');
    //   } else {
    //     afterFuture(
    //         Provider.of<Faculties>(context, listen: false)
    //             .addFaculty(_faculty.name, _faculty.email, classList),
    //         'Faculty record added');
    //   }
    // }
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
    }).then((_) {
      if (!error) {
        return showAlertDialog(title);
      }
    });
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
          title: (_faculty.name.isEmpty)
              ? const Text("Add Faculty")
              : const Text("Update Faculty"),
        ),
        body: (_isLoading)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : facultyForm);
  }

  Widget get facultyForm {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Faculty Name',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  initialValue: _faculty.name,
                  validator: (value) {
                    return null;
                  },
                  onSaved: (value) {
                    _faculty = Faculty(
                        id: _faculty.id,
                        name: value.toString(),
                        email: _faculty.email,
                        classes: _faculty.classes);
                  },
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 30),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Faculty Email',
                        border: OutlineInputBorder()),
                    textInputAction: TextInputAction.next,
                    initialValue: _faculty.email,
                    // focusNode: _subjectCodeFocusNode,
                    validator: (value) {
                      return null;
                    },
                    onSaved: (value) {
                      _faculty = Faculty(
                          id: _faculty.id,
                          name: _faculty.name,
                          email: value.toString(),
                          classes: _faculty.classes);
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: MultiSelectDialogField(
                    title: const Text('Appoint Classes'),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.8, color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    items: loadedClasses.map((c) {
                      return MultiSelectItem(c,
                          "${c.subject.subjectName} ${c.subject.subjectCode}");
                      //add details for which branch does this class belongs
                    }).toList(),
                    listType: MultiSelectListType.LIST,
                    onConfirm: (values) {
                      classList = values.map((e) {
                        return e as Class;
                      }).toList();
                      _faculty = Faculty(
                          id: _faculty.id,
                          name: _faculty.name,
                          email: _faculty.email,
                          classes: classList);
                    },
                    onSelectionChanged: (values) {
                      if (values.length != classList.length) {
                        classList = values.map((e) {
                          return e as Class;
                        }).toList();
                        _faculty = Faculty(
                            id: _faculty.id,
                            name: _faculty.name,
                            email: _faculty.email,
                            classes: classList);
                      }
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveForm,
                    child: const Text("Submit"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
