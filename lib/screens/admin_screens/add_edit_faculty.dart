import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/faculty.dart';
import 'package:shop_app/models/subject.dart';
import 'package:shop_app/providers/faculty_provider.dart';
import 'package:shop_app/providers/subject_provider.dart';

class FacultyScreen extends StatefulWidget {
  static const routeName = '/add-faculty';

  @override
  State<FacultyScreen> createState() => _FacultyScreenState();
}

class _FacultyScreenState extends State<FacultyScreen> {
  final _formKey = GlobalKey<FormState>();

  var _isLoading = false;
  var _isInit = false;

  var _faculty = Faculty(
    id: "",
    name: "",
    email: "",
  );

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (!_isInit) {
      final faculty = ModalRoute.of(context)!.settings.arguments;
      if (faculty != null) {
        _faculty = faculty as Faculty;
        _isInit = true;
      }
    }
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _subjectCodeFocusNode.dispose();
  // }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      if (_faculty.id.isNotEmpty) {
        updateFaculty();
      } else {
        addFaculty();
      }
    }
  }

  void updateFaculty() {
    bool e = false;
    Provider.of<Faculties>(context, listen: false)
        .updateFaculty(_faculty.id, _faculty.name, _faculty.email)
        .catchError((error) {
      e = true;
      return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Error while updating faculty record'),
                content: const Text('Try again later'),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: const Text('Dismiss')),
                ],
              ));
    }).then((_) {
      setState(() {
        _isLoading = false;
      });
    }).then((_) {
      if (!e) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text('Faculty Record Updated'),
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

  void addFaculty() {
    bool e = false;
    Provider.of<Faculties>(context, listen: false)
        .addFaculty(_faculty.name, _faculty.email)
        .catchError((error) {
      e = true;
      return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Error while adding faculty'),
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
      setState(() {
        _isLoading = false;
      });
    }).then((_) {
      if (!e) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text('Faculty Added'),
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
                  onFieldSubmitted: (_) {
                    // FocusScope.of(context).requestFocus(_subjectCodeFocusNode);
                  },
                  validator: (value) {
                    return null;
                  },
                  onSaved: (value) {
                    _faculty = Faculty(
                      id: _faculty.id,
                      name: value.toString(),
                      email: _faculty.email,
                    );
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
                      );
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
