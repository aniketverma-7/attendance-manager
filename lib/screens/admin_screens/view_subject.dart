import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/subject_provider.dart';
import 'package:shop_app/widgets/view_subject_card.dart';

import '../../models/subject.dart';

class ViewSubjects extends StatefulWidget {
  static const routeName = '/view-subjects';

  @override
  State<ViewSubjects> createState() => _ViewSubjectsState();
}

class _ViewSubjectsState extends State<ViewSubjects> {


  @override
  Widget build(BuildContext context) {
    List<Subject> subjects = Provider.of<Subjects>(context).subjects;
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Subjects'),
      ),
      body: buildListView(subjects)
    );
  }

  Widget buildListView(subjects) {
    return (subjects.length > 0)?ListView.builder(
      itemBuilder: (ctx, index) => SubjectCard(subjects[index]),
      itemCount: subjects.length,
    ):const Center(child: Text("No subject added at the moment"),);
  }
}

// (!_isInit)
// ? const Center(child: CircularProgressIndicator())
// : (subjects.isEmpty)
// ? const Center(
// child: Text('No Subjects added at the moment'),
// )
// : buildListView(subjects),
