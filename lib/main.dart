
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/branch_provider.dart';
import 'package:shop_app/providers/class_provider.dart';
import 'package:shop_app/providers/faculty_provider.dart';
import 'package:shop_app/providers/student_provider.dart';
import 'package:shop_app/providers/subject_provider.dart';
import 'package:shop_app/screens/admin_screens/add_edit_branch.dart';
import 'package:shop_app/screens/admin_screens/add_edit_classes.dart';
import 'package:shop_app/screens/admin_screens/add_edit_faculty.dart';
import 'package:shop_app/screens/admin_screens/add_edit_student.dart';
import 'package:shop_app/screens/admin_screens/add_edit_subject.dart';
import 'package:shop_app/screens/admin_screens/admin.dart';
import 'package:shop_app/screens/admin_screens/view_branch.dart';
import 'package:shop_app/screens/admin_screens/view_faculty.dart';
import 'package:shop_app/screens/admin_screens/view_students.dart';
import 'package:shop_app/screens/admin_screens/view_subject.dart';
import 'package:shop_app/screens/change_password.dart';
import 'package:shop_app/screens/faculty_screen/faculty_panel.dart';

import 'screens/authScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Subjects()),
        ChangeNotifierProvider(create: (context) => Students()),
        ChangeNotifierProvider(create: (context) => Faculties()),
        ChangeNotifierProvider(create: (context) => Branches()),
        ChangeNotifierProvider(create: (context) => Classes()),
        ChangeNotifierProvider(create: (context) => Auth()),
      ],
      child: MaterialApp(
        title: 'Attendance Manager',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: UserLogin(),
        routes: {
          AddSubject.routeName: (ctx)=> AddSubject(),
          ViewSubjects.routeName: (ctx)=> ViewSubjects(),
          StudentScreen.routeName: (ctx)=> StudentScreen(),
          ViewStudents.routeName: (ctx)=> ViewStudents(),
          FacultyScreen.routeName: (ctx)=> FacultyScreen(),
          ViewFaculty.routeName: (ctx)=> ViewFaculty(),
          BranchScreen.routeName: (ctx)=> BranchScreen(),
          ViewBranch.routeName: (ctx)=> ViewBranch(),
          ClassScreen.routeName: (ctx)=> ClassScreen(),
          ChangePasswordScreen.routeName: (ctx)=> ChangePasswordScreen(),
          AdminPanel.routeName: (ctx)=> AdminPanel(),
          UserLogin.routeName: (ctx)=> UserLogin(),
          FacultyPanel.routeName: (ctx)=> FacultyPanel(),
        },
      ),
    );
  }
}
