import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const String routeName = '/change-password';

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {

  final _formKey = GlobalKey<FormState>();


  void _saveForm(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: Center(
          child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: 'Change Password',
                            border: OutlineInputBorder()),
                        textInputAction: TextInputAction.done,
                        // focusNode: _subjectCodeFocusNode,
                        validator: (value) {
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
                            labelText: 'Retype Password',
                            border: OutlineInputBorder()),
                        textInputAction: TextInputAction.done,
                        // focusNode: _subjectCodeFocusNode,
                        validator: (value) {
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
          )
      ),
    );
  }
}
