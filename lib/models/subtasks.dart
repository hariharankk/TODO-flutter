import 'package:equatable/equatable.dart';

import 'groupmember.dart';

// ignore: must_be_immutable
class Subtask extends Equatable {
  /// Subtask Name/Title
  late String title;
  /// Subtask ID
  late int priority;

  /// Subtask Key
  late String subtaskKey;

  /// Has the subtask been completed
  late bool completed;

  /// Time Created
  late DateTime timeCreated;

  /// Time Updated
  late DateTime timeUpdated;

  late DateTime now = DateTime.now();

  /// Deadline
  late DateTime deadline;

  /// Not Implemented
  late String note;

  List<GroupMember> assignedTo = [];

  late List<GroupMember> allGroupMembers;

  Subtask.blank();

  Subtask(this.title, this.completed, this.note,
      this.subtaskKey, this.timeCreated, this.timeUpdated,this.priority) {
    deadline = DateTime(now.year, 12, 31);
  }

  factory Subtask.copyWith(Subtask obj) {
    return Subtask(obj.title, obj.completed, obj.note, obj.subtaskKey, obj.timeCreated, obj.timeUpdated, obj.priority);
}

  factory Subtask.fromJson(Map<String, dynamic> parsedJson) {
    return Subtask(
      parsedJson['title'],
      parsedJson['completed'],
      parsedJson['note'],
      parsedJson['subtask_key'],
      DateTime.parse(parsedJson['time_created']),
      DateTime.parse(parsedJson['time_updated']),
      parsedJson['priority'],
     );
  }

  @override
  List<Object> get props => [subtaskKey];

  @override
  String toString() {
    return title;
  }
}
