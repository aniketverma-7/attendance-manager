import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const String routeName = '/change-password';

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();

  var _isLoading = false;

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      bool e = false;
      Provider.of<Auth>(context, listen: false)
          .changePassword(passwordController.text.toString())
          .catchError((error) {
            e = true;
            showAlertDialog(error.toString());
      }).then((_) {
        if(!e) {
          showAlertDialog("Password Changed Successfully");
        }
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  Future showAlertDialog(String title) {
    return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(title),
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
        title: const Text('Change Password'),
      ),
      body: (_isLoading)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : passwordChangeForm,
    );
  }

  Widget get passwordChangeForm {
    return Center(
        child: Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              child: TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'Change Password', border: OutlineInputBorder()),
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value.toString().isEmpty) {
                    return "Please enter password";
                  }
                  return null;
                },
                onSaved: (value) {},
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'Retype Password', border: OutlineInputBorder()),
                textInputAction: TextInputAction.done,
                // focusNode: _subjectCodeFocusNode,
                validator: (value) {
                  if (value.toString().isEmpty) {
                    return "Please enter password";
                  } else if (passwordController.text.toString() !=
                      value.toString()) {
                    return "Password doesn't match";
                  }

                  return null;
                },
                onSaved: (value) {},
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveForm,
                child: const Text("Change Password"),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
