import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/branch.dart';
import 'package:shop_app/models/subject.dart';
import 'package:shop_app/providers/subject_provider.dart';


class BranchScreen extends StatefulWidget {
  static const routeName = '/add-edit-branch';

  @override
  State<BranchScreen> createState() => _BranchScreenState();
}

class _BranchScreenState extends State<BranchScreen> {
  final _formKey = GlobalKey<FormState>();

  final _subjectCodeFocusNode = FocusNode();
  var _isLoading = false;
  var _isInit = false;

  var _branch = Branch(
    id: '',
    name: '',
    students: [],
    subjects: [],
  );

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (!_isInit) {
      final branch = ModalRoute.of(context)!.settings.arguments;
      if (branch != null) {
        _branch = branch as Branch;
      }
      _isInit = true;
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
      if (_branch.id.isNotEmpty) {
        updateSubject();
      } else {
        addSubject();
      }
    }
  }

  void updateSubject() {
    // Provider.of<Subjects>(context, listen: false)
    //     .updateSubject(_subject.id, _subject.subjectCode, _subject.subjectName)
    //     .catchError((error) {
    //   return showDialog(
    //       context: context,
    //       builder: (ctx) => AlertDialog(
    //             title: const Text('Error while updating subject'),
    //             content: const Text('Try again later'),
    //             actions: [
    //               FlatButton(
    //                   onPressed: () {
    //                     Navigator.of(ctx).pop();
    //                   },
    //                   child: const Text('Dismiss')),
    //             ],
    //           ));
    // }).then((_) {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // }).then((_) {
    //   return showDialog(
    //       context: context,
    //       builder: (ctx) => AlertDialog(
    //             title: const Text('Subject Updated'),
    //             actions: [
    //               FlatButton(
    //                   onPressed: () {
    //                     Navigator.of(ctx).pop();
    //                     Navigator.of(ctx).pop();
    //                   },
    //                   child: const Text('Dismiss')),
    //             ],
    //           ));
    // });
  }

  // _isInit = true;
  void addSubject() {
    // Provider.of<Subjects>(context, listen: false)
    //     .addSubject(_subject.subjectCode, _subject.subjectName)
    //     .catchError((error) {
    //   return showDialog(
    //       context: context,
    //       builder: (ctx) => AlertDialog(
    //             title: const Text('Error while adding subject'),
    //             content: const Text('Try again later'),
    //             actions: [
    //               FlatButton(
    //                   onPressed: () {
    //                     Navigator.of(ctx).pop();
    //                   },
    //                   child: const Text('Dismiss')),
    //             ],
    //           ));
    // }).then((_) {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // }).then((_) {
    //   return showDialog(
    //       context: context,
    //       builder: (ctx) => AlertDialog(
    //             title: const Text('Subject Added'),
    //             actions: [
    //               FlatButton(
    //                   onPressed: () {
    //                     Navigator.of(ctx).pop();
    //                     Navigator.of(ctx).pop();
    //                   },
    //                   child: const Text('Dismiss')),
    //             ],
    //           ));
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: (_branch.name.isEmpty)
              ? const Text("Add Branch")
              : const Text("Update Branch"),
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
                      labelText: 'Branch Name', border: OutlineInputBorder()),
                  textInputAction: TextInputAction.next,
                  initialValue: _branch.name,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_subjectCodeFocusNode);
                  },
                  validator: (value) {
                    return null;
                  },
                  onSaved: (value) {
                    _branch = Branch(
                      id: _branch.id,
                      name: value.toString(),
                      students: _branch.students,
                      subjects: _branch.subjects,
                    );
                  },
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
