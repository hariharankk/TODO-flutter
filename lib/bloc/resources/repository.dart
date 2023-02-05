import 'dart:async';
import 'package:todolist/models/group.dart';
import 'package:todolist/models/groupmember.dart';
import 'package:todolist/models/subtasks.dart';
import 'package:todolist/models/tasks.dart';
import 'package:todolist/models/message.dart';

import 'api.dart';
import 'package:todolist/models/user.dart';

class Repository {
  final apiProvider = ApiProvider();

  Future<User> registerUser(String username, String password, String email,
          String firstname, String lastname, String phonenumber, avatar) =>
      apiProvider.registerUser(
          username, password, email, firstname, lastname, phonenumber, avatar);

  Future signinUser(String username, String password, String apiKey) =>
      apiProvider.signinUser(username, password, apiKey);


  Future<String> getApiKey() => apiProvider.getApiKey();

  Future<void> saveApiKey(String apiKey) => apiProvider.saveApiKey(apiKey);

  //Groups: Get, Post, Delete
  Future<List<Group>> getUserGroups() => apiProvider.getUserGroups();

  Future addGroup(String groupName, bool isPublic) =>
      apiProvider.addGroup(groupName, isPublic);

   Future<bool> updateGroup(Group group) => apiProvider.updateGroup(group);

  Future<dynamic> deleteGroup(String groupKey) =>
      apiProvider.deleteGroup(groupKey);

  //Group Members:  Post, Delete

  Future addGroupMember(String groupKey, String username,String role) =>
      apiProvider.addGroupMember(groupKey, username, role);

  Future<dynamic> deleteGroupMember(String groupKey, String username) =>
      apiProvider.deleteGroupMember(groupKey, username);

  //Tasks
  Future getTasks(String groupKey) => apiProvider.getTasks(groupKey);

  Future<Null> addTask(String taskName, String groupKey) async {
    apiProvider.addTask(taskName, groupKey);
  }

  Future<Null> updateTask(Task task) async {
    apiProvider.updateTask(task);
  }

  FutureOr<dynamic> deleteTask(String taskKey) async {
    apiProvider.deleteTask(taskKey);
  }

  //Subtasks
  Future getSubtasks(Task task) => apiProvider.getSubtasks(task);

  Future<Null> addSubtask(String taskKey, String subtaskName) async {
    apiProvider.addSubtask(taskKey, subtaskName);
  }

  Future<Null> updateSubtask(Subtask subtask) async {
    apiProvider.updateSubtask(subtask);
  }

  FutureOr<dynamic> deleteSubtask(String subtaskKey) async {
    apiProvider.deleteSubtask(subtaskKey);
  }

  ///Search For User
  Future searchUser(String searchTerm) => apiProvider.searchUser(searchTerm);

  ///Group Members: Get, Post, Delete
  Future<List<GroupMember>> getUsersAssignedToSubtask(
          String subtaskKey) async =>
      await apiProvider.getUsersAssignedToSubtask(subtaskKey);

  Future assignSubtaskToUser(String subtaskKey, String username) =>
      apiProvider.assignSubtaskToUser(subtaskKey, username);

  Future<void> unassignSubtaskToUser(String subtaskKey, String username) =>
      apiProvider.unassignSubtaskToUser(subtaskKey, username);

  Future send_message(String message, String sender,String subtaskKey) => apiProvider.send_message(message, sender,subtaskKey);

  Future<List<Message>> get_message(String subtaskKey) => apiProvider.getMessages(subtaskKey);
}

final repository = Repository();
