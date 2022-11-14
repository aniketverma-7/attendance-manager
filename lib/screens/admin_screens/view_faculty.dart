import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/faculty_provider.dart';
import 'package:shop_app/providers/subject_provider.dart';
import 'package:shop_app/widgets/view_faculty_card.dart';
import 'package:shop_app/widgets/view_subject_card.dart';

import '../../models/faculty.dart';
import '../../models/subject.dart';

class ViewFaculty extends StatefulWidget {
  static const routeName = '/view-faculty';

  @override
  State<ViewFaculty> createState() => _ViewFacultyState();
}

class _ViewFacultyState extends State<ViewFaculty> {
  var _isLoading = true;
  var _isInit = false;
  String message = "";
  List<Faculty> _faculties = [];

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    if (!_isInit) {
      Provider.of<Faculties>(context, listen: false)
          .fetchFaculty()
          .catchError((error) {
        print(error);
        setState(() {
          message = "Server Error, unable to fetch right now";
        });
      }).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    _faculties = Provider.of<Faculties>(context).faculties;
    return Scaffold(
        appBar: AppBar(
          title: const Text('View Faculty'),
        ),
        body: (_isLoading)
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : buildListView(_faculties));
  }

  Widget buildListView(_faculties) {
    return (_faculties.length > 0)
        ? ListView.builder(
            itemBuilder: (ctx, index) => FacultyCard(_faculties[index]),
            itemCount: _faculties.length,
          )
        : Center(
            child: Text(message.isNotEmpty
                ? message
                : "No faculty added in the department at the moment"),
          );
  }
}
