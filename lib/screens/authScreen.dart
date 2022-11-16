import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/faculty_screen/faculty_panel.dart';

import 'admin_screens/admin.dart';

class UserLogin extends StatefulWidget {
  static const routeName = '/auth';

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  var _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    userController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(40, 85, 174, 1),
              Color.fromRGBO(114, 146, 204, 1)
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: (_isLoading)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : authBody,
      ),
    );
  }

  Widget get authBody {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextColumn(),
              buildAuthCard(),
            ],
          ),
        ),
      ),
    );
  }

  void changeState(bool state) {
    setState(() {
      _isLoading = state;
    });
  }

  void login() {
    if (_formKey.currentState!.validate()) {
      changeState(true);
      bool e = false;
      String userName = userController.text.toString();
      String password = passwordController.text.toString();
      Provider.of<Auth>(context, listen: false)
          .loginUser(userName)
          .catchError((error) {
        e = true;
        showAlertDialog(error.toString());
      }).then((_) {
        if (!e) {
          if (Provider.of<Auth>(context, listen: false)
              .verifyCredentials(password)) {
            var providerTag =
                Provider.of<Auth>(context, listen: false).tag.toString();
            String screenName = '/auth';
            if (providerTag == 'FACULTY') {
              screenName = FacultyPanel.routeName;
            } else if (providerTag == 'STUDENT') {
            } else if (providerTag == 'ADMIN') {
              screenName = AdminPanel.routeName;
            }
            Navigator.of(context).pushReplacementNamed(screenName);
          } else {
            showAlertDialog("Invalid credentials for the user.");
          }
        }
        changeState(false);
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
                    },
                    child: const Text('Dismiss')),
              ],
            ));
  }

  Widget buildTextColumn() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Hi",
              style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "Login to continue",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white10,
                  fontWeight: FontWeight.bold),
            )
          ]),
    );
  }

  Widget buildAuthCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 15, right: 15, top: 50, bottom: 50),
      child: Card(
        color: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: TextFormField(
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return "Please enter username";
                        }
                        return null;
                      },
                      controller: userController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'User ID',
                      )),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: TextFormField(
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return "Please enter password";
                        }
                        return null;
                      },
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      )),
                ),
                Container(
                  width: double.infinity,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: ElevatedButton(
                    onPressed: login,
                    child: const Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "Login",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
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
