import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/admin_screens/add_edit_faculty.dart';
import 'package:shop_app/screens/admin_screens/add_edit_subject.dart';
import 'package:shop_app/screens/admin_screens/view_faculty.dart';
import 'package:shop_app/screens/admin_screens/view_students.dart';
import 'package:shop_app/screens/admin_screens/view_subject.dart';
import 'package:shop_app/screens/admin_screens/add_edit_student.dart';
import 'package:shop_app/widgets/admin_item.dart';

import '../../models/subject.dart';
import '../../providers/subject_provider.dart';
import '../../widgets/admin_drawer.dart';
import 'add_edit_branch.dart';

class AdminPanel extends StatefulWidget {
  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  var adminOption = const [
    'Add Student',
    'View Students',
    'Add Faculty',
    'View Faculty',
    'Add Subject',
    'View Subject',
    'Add Branch',
    'View Branch',
  ];

  var _isInit = false;
  var _isLoading = true;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (!_isInit) {
      Provider.of<Subjects>(context).fetchSubjects().catchError((error){
        setState(() {
          _isLoading = false;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      drawer: AdminDrawer(),
      body: (_isLoading)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : adminControls,
    );
  }

  Widget get adminControls {
    return Container(
      margin: const EdgeInsets.all(10),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1,
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return AdminOption(adminOption[index], (index) {
            switch (index) {
              case 0:
                Navigator.of(context).pushNamed(StudentScreen.routeName);
                break;

              case 1:
                Navigator.of(context).pushNamed(ViewStudents.routeName);
                break;

              case 2:
                Navigator.of(context).pushNamed(FacultyScreen.routeName);
                break;

              case 3:
                Navigator.of(context).pushNamed(ViewFaculty.routeName);
                break;

              case 4:
                Navigator.of(context).pushNamed(AddSubject.routeName);
                break;

              case 5:
                Navigator.of(context).pushNamed(ViewSubjects.routeName);
                break;

              case 6:
                Navigator.of(context).pushNamed(BranchScreen.routeName);
                break;

              case 7:
                break;
            }
          }, index);
        },
        itemCount: adminOption.length,
      ),
    );
  }
}
