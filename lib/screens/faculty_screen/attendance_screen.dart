import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/subject.dart';
import 'package:shop_app/providers/attendance_provider.dart';
import 'package:swipeable_card_stack/swipeable_card_stack.dart';

import '../../models/attendance.dart';
import '../../models/student.dart';

class AttendanceScreen extends StatefulWidget {
  static const String routeName = 'attendance-screen';

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  var _isInit = false;
  var _isLoading = false;

  List<Student> students = [];
  List<Attendance> failedAttendance = [];
  Subject subject = Subject(id: '', subjectCode: '', subjectName: '');

  var count = 0;
  SwipeableCardSectionController _cardController =
      SwipeableCardSectionController();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (!_isInit) {
      final data =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      if (data != null) {
        students = data['students'] as List<Student>;
        subject = data['subject'] as Subject;
      }
      _isInit = true;
    }
  }

  void afterFuture(future, title) {
    bool error = false;
    future = future as Future<void>;
    future.catchError((error) {
      error = true;
      return showAlertDialog('Server error :(');
    }).then((_) {
      setState(() {
        _isLoading = false;
      });
    }).then((_){
      if(!error){
        return showAlertDialog(title);
      }
    });
  }

  Future showAlertDialog(String title) {
    return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(title),
          content: Text((title.contains('Server'))?'Try again later':''),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(ctx).pop();
                },
                child: const Text('Dismiss')),
          ],
        ));
  }

  void upload(Attendance attendance){
    bool e = false;
    Provider.of<AttendanceProvider>(context, listen: false).addAttendance(attendance).catchError((error){
      //TODO: Re-upload failed attendance again.
      failedAttendance.add(attendance);
      showAlertDialog('Unable to upload attendance of ${attendance.enrollment}');
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
      ),
      body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SwipeableCardsSection(
                  cardHeightTopMul: 1,
                  cardController: _cardController,
                  context: context,
                  //add the first 3 cards (widgets)
                  items: students.map((e) {
                    return CardView(e);
                  }).toList(),
                  //Get card swipe event callbacks
                  onCardSwiped: (dir, index, widget) {
                    if (dir == Direction.right) {
                      final data = students[index];
                      upload(Attendance(
                        data.enrollment,
                        subject,
                        true,
                        DateTime.now(),
                      ));
                    }
                    else{
                        final data = students[index];
                        upload(Attendance(
                          data.enrollment,
                          subject,
                          false,
                          DateTime.now(),
                        ));
                    }
                    count += 1;
                    if (count == students.length) {
                     Navigator.of(context).pop();
                    }
                  },
                ),
              ],
              //other children
            ),
    );
  }
}

class CardView extends StatelessWidget {
  final Student student;

  CardView(this.student);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Card(
        elevation: 5,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                student.name,
                style: const TextStyle(fontSize: 18),
              ),
              Text(
                student.enrollment,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Text(
                    "Left for absent",
                    style: TextStyle(fontSize: 18, color: Colors.black38),
                  ),
                  Text(
                    "Right for present",
                    style: TextStyle(fontSize: 18, color: Colors.black38),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
