import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/admin_screens/add_edit_classes.dart';
import 'package:shop_app/screens/change_password.dart';

import '../providers/auth.dart';
import '../screens/authScreen.dart';

class FacultyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Department of Computer Science and Information Technology',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Spacer(),
                  Text('Username: ${Provider.of<Auth>(context, listen: false).userName}',
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.white70),
                  )
                ],
              ),),
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
              Navigator.of(context).pushReplacementNamed(UserLogin.routeName);
            },
          )
        ],
      ),
    );
    ;
  }
}
