class Subject {
  final String id;
  final String subjectCode;
  final String subjectName;

  Subject({
    required this.id,
    required this.subjectCode,
    required this.subjectName,
  });

  @override
  String toString() {
    return 'Subject{id: $id, subjectCode: $subjectCode, subjectName: $subjectName}';
  }
}
