import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/branch.dart';

import '../../providers/branch_provider.dart';

class BranchScreen extends StatefulWidget {
  static const routeName = '/add-edit-branch';

  @override
  State<BranchScreen> createState() => _BranchScreenState();
}

class _BranchScreenState extends State<BranchScreen> {
  final _formKey = GlobalKey<FormState>();

  var _isLoading = false;
  var _isInit = false;

  var _branch = Branch(
    id: '',
    name: '',
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

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      if (_branch.id.isNotEmpty) {
        afterFuture(
          Provider.of<Branches>(context, listen: false)
              .updateBranch(_branch.id, _branch.name),
          'Branch updated successfully',
        );
      } else {
        afterFuture(
          Provider.of<Branches>(context, listen: false)
              .addBranch(_branch.name),
          'Branch added successfully',
        );
      }
    }
  }

  void afterFuture(future, title) {
    bool error = false;
    future = future as Future<void>;
    future.catchError((error) {
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
            : branchForm);
  }

  Widget get branchForm {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Branch Name', border: OutlineInputBorder()),
                    textInputAction: TextInputAction.next,
                    initialValue: _branch.name,
                    validator: (value) {
                      return null;
                    },
                    onSaved: (value) {
                      _branch = Branch(
                        id: _branch.id,
                        name: value.toString(),
                      );
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
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
