import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/branch_provider.dart';
import 'package:shop_app/screens/admin_screens/add_edit_branch.dart';
import 'package:shop_app/screens/admin_screens/add_edit_student.dart';

import '../models/branch.dart';

class BranchCard extends StatelessWidget {
  final Branch _branch;

  BranchCard(this._branch);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: ValueKey(_branch.id),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          Provider.of<Branches>(context, listen: false)
              .removeBranch(_branch.id);
        },
        confirmDismiss: (direction) {
          return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Are you sure ?'),
                  content: const Text(
                      'Do you want to remove this branch from department.'),
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
            title: Text(_branch.name),
            subtitle: const Text('CSIT Department'),
            trailing: InkWell(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(BranchScreen.routeName, arguments: _branch);
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