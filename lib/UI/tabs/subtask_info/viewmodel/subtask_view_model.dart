import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/bloc/resources/repository.dart';
import 'package:todolist/models/groupmember.dart';
import 'package:todolist/models/subtasks.dart';

class SubtaskViewModel {
  final Subtask subtask;
  final SubtaskBloc subtaskBloc;
  final List<GroupMember> members;

  SubtaskViewModel(
      {required this.subtask,
      required this.subtaskBloc,
      required this.members});

  String get title {
    return this.subtask.title;
  }

  String get note {
    return this.subtask.note;
  }

  set note(String note) {
    subtask.note = note;
  }

  void selected(GroupMember groupMember, bool selected) {
    groupMember.selectedForAssignment = selected;
  }

  DateTime get deadline {
    return this.subtask.deadline;
  }

  set deadline(DateTime deadline) {
    subtask.deadline = deadline;
  }

  List<GroupMember> get assignedTo {
    return this.subtask.assignedTo;
  }

  List<GroupMember> get allGroupMembers {
    return this.subtask.allGroupMembers;
  }

  Future<void> getUsersAssignedtoSubtask() async {
    subtask.assignedTo =
        await repository.getUsersAssignedToSubtask(subtask.subtaskKey);
    //initialAssignedMembers = subtask.assignedTo;
    for (GroupMember user in members) {
      if (subtask.assignedTo.contains(user)) {
        selected(user, true);
      } else
        selected(user, false);
    }
  }

  bool alreadySelected(int index) => members[index].selectedForAssignment;

  Future<void> assignSubtaskToUser(int index) async {
    try {
      await repository.assignSubtaskToUser(
          subtask.subtaskKey, members[index].username);
    } catch (e) {
      throw e;
    }
  }

  Future<void> unassignSubtaskToUser(int index) async {
    try {
      await repository.unassignSubtaskToUser(
          subtask.subtaskKey, members[index].username);
    } catch (e) {
      throw e;
    }

  }


  Future<void> updateSubtaskInfo() async {
    await subtaskBloc.updateSubtaskInfo(this.subtask);
  }
}
