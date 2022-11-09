import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/admin_screens/add_edit_subject.dart';
import 'package:shop_app/screens/admin_screens/view_subject.dart';
import 'package:shop_app/screens/admin_screens/add_edit_student.dart';
import 'package:shop_app/widgets/admin_item.dart';

import '../../models/subject.dart';
import '../../providers/subject_provider.dart';

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
    'View Subject'
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
                print("d");
                break;

              case 2:
                print("d");
                break;

              case 3:
                print("d");
                break;

              case 4:
                Navigator.of(context).pushNamed(AddSubject.routeName,
                    arguments: Subject(
                      id: "",
                      subjectCode: '',
                      subjectName: '',
                    ));
                break;

              case 5:
                Navigator.of(context).pushNamed(ViewSubjects.routeName);
                break;
            }
          }, index);
        },
        itemCount: adminOption.length,
      ),
    );
  }
}
