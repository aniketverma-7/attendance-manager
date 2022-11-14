import 'package:flutter/material.dart';

class AdminDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Department of Computer Science and Information Technology',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              )),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Department Details'),
            onTap: (){

            },
          )
        ],
      ),
    );
    ;
  }
}
