import 'package:flutter/material.dart';
import 'package:shop_app/models/student.dart';
import 'package:shop_app/models/subject.dart';

class ClassCard extends StatelessWidget {
  final Subject subject;
  final Function onClick;
  ClassCard(this.subject,this.onClick);


  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        onTap: () {
          onClick(subject);
        },
        child: Card(
          elevation: 5,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Container(
            margin: EdgeInsets.all(10),
            child: Center(
              child: Text(
                "${subject.subjectName} ${subject.subjectCode}",
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
      ),
    );;
  }
}
