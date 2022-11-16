import 'package:flutter/material.dart';
import 'package:shop_app/screens/admin_screens/add_edit_classes.dart';
import 'package:shop_app/screens/change_password.dart';

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
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Department Details'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.library_books),
            title: const Text('Add Classes'),
            onTap: () {
              Navigator.of(context).pushNamed(ClassScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.password),
            title: const Text('Change Password'),
            onTap: () {
              Navigator.of(context).pushNamed(ChangePasswordScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.of(context).pushNamed(ClassScreen.routeName);
            },
          )
        ],
      ),
    );
    ;
  }
}
