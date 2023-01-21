import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/bloc/resources/repository.dart';
import 'package:todolist/models/groupmember.dart';
import 'package:todolist/models/subtasks.dart';
import 'package:todolist/bloc/resources/injection.dart';

class SubtaskViewModel {
  //final Subtask subtask;

  final List<GroupMember> members;

  SubtaskViewModel(
      {
      required this.members});

  String get title {
    return locator<Subtask>().title;
  }

set priority(int index){
  locator<Subtask>().priority=index;
}

  String get note {
    return locator<Subtask>().note;
  }

  set note(String note) {
    locator<Subtask>().note = note;
  }


  DateTime get deadline {
    return locator<Subtask>().deadline;
  }

  set deadline(DateTime deadline) {
    locator<Subtask>().deadline = deadline;
  }



  Future<void> getUsersAssignedtoSubtask() async {
    locator<Subtask>().assignedTo =
        await repository.getUsersAssignedToSubtask(locator<Subtask>().subtaskKey);
    //initialAssignedMembers = subtask.assignedTo;
    for (GroupMember user in members) {
      if (locator<Subtask>().assignedTo.contains(user)) {
        selected(user, true);
      } else
        selected(user, false);
    }
  }
  void selected(GroupMember groupMember, bool selected) {
    groupMember.selectedForAssignment = selected;
  }

  bool alreadySelected(int index) => members[index].selectedForAssignment;

  Future<void> assignSubtaskToUser(int index) async {
    try {
      await repository.assignSubtaskToUser(
          locator<Subtask>().subtaskKey, members[index].username);
    } catch (e) {
      throw e;
    }
  }

  Future<void> unassignSubtaskToUser(int index) async {
    try {
      await repository.unassignSubtaskToUser(
          locator<Subtask>().subtaskKey, members[index].username);
    } catch (e) {
      throw e;
    }

  }


  Future<void> updateSubtaskInfo() async {
    await locator<SubtaskBloc>().updateSubtaskInfo(locator<Subtask>());
  }
}
