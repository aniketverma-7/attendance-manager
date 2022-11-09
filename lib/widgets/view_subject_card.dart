import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/admin_screens/add_edit_subject.dart';

import '../models/subject.dart';
import '../providers/subject_provider.dart';

class SubjectCard extends StatelessWidget {
  final Subject _subject;

  SubjectCard(this._subject);

  @override
  Widget build(BuildContext context) {
    print(_subject.id);
    return Dismissible(
        key: ValueKey(_subject.id),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          Provider.of<Subjects>(context, listen: false)
              .removeSubject(_subject.id);
        },
        confirmDismiss: (direction) {
          return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Are you sure ?'),
                  content: const Text(
                      'Do you want to remove the item from the cart ?'),
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
            title: Text(_subject.subjectName),
            subtitle: Text(_subject.subjectCode),
            trailing: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(AddSubject.routeName,arguments: _subject);
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

// return ListTile(
// onTap: (){},
// title: Text(_subject.subjectName),
// subtitle: Text(_subject.subjectCode),
// );

// Card(
// margin: EdgeInsets.symmetric(horizontal: width * .01,vertical: 10),
// child: Row(
// children: [
// Container(
// width: width * .79,
// child: Column(
// mainAxisAlignment: MainAxisAlignment.start,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Padding(
// padding: EdgeInsets.all(2),
// child: Text(_subject.subjectName)),
// Padding(
// padding: EdgeInsets.all(2),
// child: Text(_subject.subjectCode)),
// ],
// ),
// ),
// Container(
// width: width * .19,
// child: Row(
// children: const [
// Icon(
// Icons.edit,
// color: Colors.blue,
// ),
// Icon(
// Icons.delete,
// color: Colors.deepOrange,
// )
// ],
// ),
// )
// ],
// ));
