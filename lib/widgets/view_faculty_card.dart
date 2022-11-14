import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/faculty.dart';
import 'package:shop_app/providers/faculty_provider.dart';
import 'package:shop_app/screens/admin_screens/add_edit_subject.dart';

import '../models/subject.dart';
import '../providers/subject_provider.dart';
import '../screens/admin_screens/add_edit_faculty.dart';

class FacultyCard extends StatelessWidget {
  final Faculty _faculty;

  FacultyCard(this._faculty);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: ValueKey(_faculty.id),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          Provider.of<Faculties>(context, listen: false)
              .removeFaculty(_faculty.id);
        },
        confirmDismiss: (direction) {
          return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Are you sure ?'),
                  content: const Text(
                      'Do you want to remove this faculty from the system.'),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text('No')),
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text('Yes')),
                  ],
                );
              });
        },
        background: Container(
          alignment: Alignment.centerRight,
          color: Theme.of(context).errorColor,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 30,
          ),
        ),
        child: Card(
          margin: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 15,
          ),
          child: ListTile(
            title: Text(_faculty.name),
            subtitle: Text(_faculty.email),
            trailing: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(FacultyScreen.routeName,arguments: _faculty);
              },
              child: const Icon(
                Icons.edit,
                color: Colors.blue,
              ),
            ),
          ),
        ));
  }
}
