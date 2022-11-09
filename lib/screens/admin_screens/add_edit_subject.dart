import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/subject.dart';
import 'package:shop_app/providers/subject_provider.dart';

class AddSubject extends StatefulWidget {
  static const routeName = '/add-subject';

  @override
  State<AddSubject> createState() => _AddSubjectState();
}

class _AddSubjectState extends State<AddSubject> {
  final _formKey = GlobalKey<FormState>();

  final _subjectCodeFocusNode = FocusNode();
  var _isLoading = false;
  var _isInit = false;

  var _subject = Subject(
    id: "",
    subjectCode: "",
    subjectName: "",
  );

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (!_isInit) {
      final subject = ModalRoute.of(context)!.settings.arguments as Subject;
      if (subject.subjectCode != null) {
        _subject = subject;
        _isInit = true;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _subjectCodeFocusNode.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      if (_subject.id.isNotEmpty) {
        updateSubject();
      } else {
        addSubject();
      }
    }
  }

  void updateSubject() {
    Provider.of<Subjects>(context, listen: false)
        .updateSubject(_subject.id, _subject.subjectCode, _subject.subjectName)
        .catchError((error) {
      return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Error while adding subject'),
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
      return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Subject Updated'),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        Navigator.of(ctx).pop();
                      },
                      child: const Text('Dismiss')),
                ],
              ));
    });
  }

  // _isInit = true;
  void addSubject() {
    Provider.of<Subjects>(context, listen: false)
        .addSubject(_subject.subjectCode, _subject.subjectName)
        .catchError((error) {
      return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Error while adding subject'),
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
      return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Subject Added'),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        Navigator.of(ctx).pop();
                      },
                      child: const Text('Dismiss')),
                ],
              ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: (_subject.subjectName.isEmpty)
              ? const Text("Add Subject")
              : const Text("Update Subject"),
        ),
        body: (_isLoading)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : subjectForm);
  }

  Widget get subjectForm {
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
                      labelText: 'Subject Name', border: OutlineInputBorder()),
                  textInputAction: TextInputAction.next,
                  initialValue: _subject.subjectName,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_subjectCodeFocusNode);
                  },
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return "Subject name is required";
                    } else if (value.toString().length < 5) {
                      return "Enter valid subject name";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _subject = Subject(
                      id: _subject.id,
                      subjectCode: _subject.subjectCode,
                      subjectName: value.toString(),
                    );
                  },
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 30),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Subject Code',
                        border: OutlineInputBorder()),
                    textInputAction: TextInputAction.next,
                    initialValue: _subject.subjectCode,
                    focusNode: _subjectCodeFocusNode,
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return "Subject code is required";
                      } else if (value.toString().length < 3) {
                        return "Enter valid subject code";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _subject = Subject(
                        id: _subject.id,
                        subjectCode: value.toString(),
                        subjectName: _subject.subjectName,
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
