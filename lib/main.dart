
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/student_provider.dart';
import 'package:shop_app/providers/subject_provider.dart';
import 'package:shop_app/screens/admin_screens/add_edit_student.dart';
import 'package:shop_app/screens/admin_screens/add_edit_subject.dart';
import 'package:shop_app/screens/admin_screens/admin.dart';
import 'package:shop_app/screens/admin_screens/view_subject.dart';

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
        home: AdminPanel(),
        routes: {
          AddSubject.routeName: (ctx)=> AddSubject(),
          ViewSubjects.routeName: (ctx)=> ViewSubjects(),
          StudentScreen.routeName: (ctx)=> StudentScreen(),
        },
      ),
    );
  }
}
