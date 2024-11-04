import 'dart:convert';

class TaskModel {
  final String id;
  String title;
  bool isCompelted;

  TaskModel({
    required this.id,
    required this.title,
    this.isCompelted = false,
  });

  @override
  String toString() =>
      'TaskModel(id:$id , title:$title,isCompleted:$isCompelted)';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'isCompleted': isCompelted,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as String,
      title: map['title'] as String,
      isCompelted: map['isCompleted'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
