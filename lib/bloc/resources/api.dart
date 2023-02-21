import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:todolist/models/group.dart';
import 'package:todolist/models/groupmember.dart';
import 'package:todolist/models/message.dart';
import 'package:todolist/models/subtasks.dart';
import 'package:todolist/models/tasks.dart';
import 'dart:convert';

import 'package:todolist/jwt.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';

class ApiProvider {
  Client client = Client();
  JWT jwt= JWT();
  String Token='';
  //static String baseURL = "https://taskmanager-group-pro.herokuapp.com/api";
  //static Uri baseURL = 'https://taskmanager-group-stage.herokuapp.com/api';
  //static String baseURL = "http://10.0.2.2:5000/api";

  static String stageHost = '7b41-35-227-11-103.ngrok.io';
  static String productionHost = 'taskmanager-group-pro.herokuapp.com';
  static String localhost = "10.0.2.2:5000";
  Uri signinURL = Uri(scheme: 'http', host: stageHost, path: '/api/login');
  Uri userURL = Uri(scheme: 'http', host: stageHost, path: '/api/register');
  Uri userupdateURL = Uri(scheme: 'http', host: stageHost, path: '/api/userupdate');

  Uri taskaddURL = Uri(scheme: 'http', host: stageHost, path: '/api/tasks-add');
  Uri taskupdateURL = Uri(scheme: 'http', host: stageHost, path: '/api/tasks-update');

  Uri subtaskaddURL = Uri(scheme: 'http', host: stageHost, path: '/api/subtasks-add');
  Uri subtaskupdateURL = Uri(scheme: 'http', host: stageHost, path: '/api/subtasks-update');

  Uri groupaddURL = Uri(scheme: 'http', host: stageHost, path: '/api/group-add');
  Uri groupupdateURL = Uri(scheme: 'http', host: stageHost, path: '/api/group-update');

  Uri groupmemberaddURL = Uri(scheme: 'http', host: stageHost, path: '/api/groupmember-add');

  Uri searchURL = Uri(scheme: 'http', host: stageHost, path: '/api/search');
  Uri groupmemberupdateURL = Uri(scheme: 'http', host: stageHost, path: '/api/groupmember-update');
  Uri assignedtouserhaddURL = Uri(scheme: 'http', host: stageHost, path: '/api/assignedtouserhURL-add');

  Uri sendmessage = Uri(scheme: 'http', host: stageHost, path: '/api/message_send');


  // User CRUD Functions
  /// Sign Up
  Future<GroupMember> registerUser(String password, String email,
      String phonenumber,String username) async {

    print(userURL);
    final response = await client.post(
      userURL,
        headers: {
          "Access-Control-Allow-Origin": "*", // Required for CORS support to work
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      body: jsonEncode({
        "emailaddress": email,
        "password": password,
        "phonenumber": phonenumber,
        'username':username
      }),
    );
    final Map result = json.decode(response.body);

    if (result['status'] == true) {
      // If the call to the server was successful, parse the JSON

      print(result['token'].runtimeType);
      await jwt.store_token(result['token']);
      return GroupMember.fromJson(result["data"]);
    } else {
      // If that call was not successful, throw an error.
      throw Exception(result["status"]);
    }
  }

  /// Sign User In using username and password or API_Key
  Future signinUser(String email, String password) async {
    print(signinURL);
    final response = await client.post(
      signinURL,
      headers: {
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        "emailaddress": email,
        "password": password,

      }),
    );
    final Map result = json.decode(response.body);
    print(result['status']);
    if (result['status'] == true) {
      // If the call to the server was successful, parse the JSON

      print(result['token'].runtimeType);
      await jwt.store_token(result['token']);

      await Future<void>.delayed(const Duration(milliseconds: 200));
      return GroupMember.fromJson(result["data"]);
    } else {
      // If that call was not successful, throw an error.
      throw Exception(result["status"]);
    }
  }

  /// Edit Profile


  /// Group CRUD Functions
  /// Get a list of the User's Groups
  Future<List> getUserGroups() async {
    final Token = await jwt.read_token();
    final queryParameters = {'username':userBloc.getUserObject().username};
    Uri groupURL = Uri(scheme: 'http', host: stageHost, path: '/api/group',queryParameters: queryParameters);
    List<Group> groups = [];
    List data;
      final response = await client.get(
        groupURL,
        headers: {
          "Access-Control-Allow-Origin": "*", // Required for CORS support to work
          "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
          "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
          'x-access-token': Token
        },
          );
      final Map result = json.decode(response.body);
      var roles = result['roles'];

      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON
        for (Map<String, dynamic> json_ in result["data"]) {
          try {
            Group group = Group.fromJson(json_);
            group.members = await getGroupMembers(group.groupKey);
            groups.add(group);
          } catch (Exception) {
            print(Exception);
          }
        }
        data=[groups,roles];
        return data;
      } else {
        // If that call was not successful, throw an error.
        throw Exception(result["status"]);
      }

    return groups;
  }

  /// Add a Group
  Future addGroup(String groupName, bool isPublic) async {
    print(groupaddURL);
    final Token = await jwt.read_token();
    final response = await client.post(
      groupaddURL,
      headers: {
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        'x-access-token': Token,
        "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS"
      },
      body: jsonEncode({
        'username':userBloc.getUserObject().username,
        "name": groupName,
        "is_public": isPublic,
      }),
    );
    if (response.statusCode == 200) {
      final Map result = json.decode(response.body);
      Group addedGroup = Group.fromJson(result["data"]);
      //print("Group: " + addedGroup.name + " added");
      return addedGroup.groupKey;
    } else {
      // If that call was not successful, throw an error.
      final Map result = json.decode(response.body);
      print(result["status"]);
      throw Exception(result["status"]);
    }
  }

  /// Update Group Info
  Future<bool> updateGroup(Group group) async {
    final Token = await jwt.read_token();
    final response = await client.patch(
      groupupdateURL,
      headers: {
        'x-access-token': Token,
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS"},
      body: jsonEncode({"group_key":group.groupKey,"name": group.name, "is_public": group.isPublic}),
    );
    final Map result = json.decode(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(result["status"]);
    }
  }

  /// Delete a Group
  Future deleteGroup(String groupKey) async {
    final Token = await jwt.read_token();
    final queryParameters = {
      "group_key": groupKey,
    };
    Uri groupdeleteURL = Uri(scheme: 'http', host: stageHost, path: '/api/group-delete',queryParameters: queryParameters);
    final response = await client.delete(
      groupdeleteURL,
      headers: {
        'x-access-token': Token,
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "GET, OPTIONS"},
    );
    if (response.statusCode == 200) {
    } else {
      final Map result = json.decode(response.body);
      throw Exception(result["status"]);
    }
  }

// GroupMember CRUD Functions
  /// Get a list of the Group's Members.
  Future<List<GroupMember>> getGroupMembers(String groupKey) async {
    final Token = await jwt.read_token();
    final queryParameters = {
      "groupKey":groupKey,
    };
    Uri groupmemberURL = Uri(scheme: 'http', host: stageHost, path: '/api/groupmember-get',queryParameters: queryParameters);
    final response = await client.get(
      groupmemberURL,
      headers: {
        'x-access-token': Token,
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      },
    );
    final Map result = json.decode(response.body);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      List<GroupMember> groupMembers = [];
      for (Map<String, dynamic> json_ in result["data"]) {
        try {
          groupMembers.add(GroupMember.fromJsonwithrole(json_));
        } catch (Exception) {
          print(Exception);
          //throw Exception;
        }
      }
      return groupMembers;
    } else {
      // If that call was not successful, throw an error.
      throw Exception(result["status"]);
    }
  }

  /// Add a Group Member to the Group.
  /// * GroupKey: Unique Group Identifier
  /// * Username: Group Member's Username to be added
  Future addGroupMember(String groupKey, String username,String role) async {
    final Token = await jwt.read_token();
    print('${role},${username}');
    if (role==''){
      role='பார்வையாளர்';
    }
    final response = await client.post(
      groupmemberaddURL,
      headers: {
        'x-access-token': Token,
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS"},
      body: jsonEncode({
        "groupKey":groupKey,
        "username": username,
        "role":role
      }),
    );
    final Map result = json.decode(response.body);
    if (response.statusCode == 200) {
    } else {
      print(result["status"]);
      throw Exception(result["status"]);
    }
  }

  Future updateGroupMemberrole(String groupKey, String username,String role) async {
    final Token = await jwt.read_token();
    if (role==''){
      role='பார்வையாளர்';
    }
    final response = await client.patch(
      groupmemberupdateURL,
      headers: {
        'x-access-token': Token,
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS"},
      body: jsonEncode({
        "groupKey":groupKey,
        "username": username,
        "role":role
      }),
    );
    final Map result = json.decode(response.body);
    if (response.statusCode == 200) {
    } else {
      print(result["status"]);
      throw Exception(result["status"]);
    }
  }

  /// Delete a Group Member
  /// * GroupKey: Unique Group Identifier
  /// * Username: Group Member's Username to be added
  Future deleteGroupMember(String groupKey, String username) async {
    final Token = await jwt.read_token();
    final queryParameters = {
      "groupKey":groupKey,
    "username": username,
    };
    Uri groupmemberdeleteURL = Uri(scheme: 'http', host: stageHost, path: '/api/groupmember-delete',queryParameters: queryParameters);
    final response = await client.delete(
      groupmemberdeleteURL,
      headers: {
        'x-access-token': Token,
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "GET, OPTIONS"},
    );

    if (response.statusCode == 200) {
    } else if (response.statusCode == 400 ||
        response.statusCode == 401 ||
        response.statusCode == 404) {
      final Map result = json.decode(response.body);
      throw Exception(result["status"]);
    }
  }

//Task CRUD Functions
  /// Get a list of the Group's Tasks
  /// * GroupKey: Unique group identifier
  Future<List<Task>> getTasks(String groupKey) async {
    final Token = await jwt.read_token();
    final queryParameters = {"group_key": groupKey};
    Uri taskURL = Uri(scheme: 'http', host: stageHost, path: '/api/tasks-get',queryParameters: queryParameters);
    final response = await client.get(
      taskURL,
      headers: {
        'x-access-token': Token,
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Credentials": 'true',
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      },
    );
    final Map result = json.decode(response.body);
    if (response.statusCode == 200) {
      List<Task> tasks = [];
      for (Map<String, dynamic> json_ in result["data"]) {
        try {
          Task task = Task.fromJson(json_);
          tasks.add(task);
        } catch (Exception) {
          print(Exception);
        }
      }
      return tasks;
    } else {
      throw Exception(result["status"]);
    }
  }

  /// Add a Task to the Group.
  ///
  /// * Task Name: Name of the task
  /// * GroupKey: Unique Group Identifier
  /// * Index: Position within Group's task list
  /// * Completed: True or False, Has the task been completed
  Future addTask(String taskName, String groupKey) async {
    final Token = await jwt.read_token();
    final response = await client.post(
      taskaddURL,
      headers: {
        'x-access-token': Token,
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS"},
      body: jsonEncode({"title": taskName, "group_key": groupKey}),
    );
    if (response.statusCode == 201) {
    } else {
      final Map result = json.decode(response.body);
      throw Exception(result["status"]);
    }
  }

  /// Update Task Info
  Future updateTask(Task task) async {
    final Token = await jwt.read_token();
    final response = await client.patch(
      taskupdateURL,
      headers: {
        'x-access-token': Token,
          "Access-Control-Allow-Origin": "*", // Required for CORS support to work
          "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
          "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
          "Access-Control-Allow-Methods": "POST, OPTIONS"},
      body: jsonEncode({"task_key":task.taskKey,"completed": task.completed,
                                "priority":task.priority}),
    );
    if (response.statusCode == 200) {
    } else {
      print(json.decode(response.body));
      throw Exception('Failed to update tasks');
    }
  }

  Future deleteTask(String taskKey) async {
    final Token = await jwt.read_token();
    final queryParameters = {"task_key":taskKey};
    Uri taskdeleteURL = Uri(scheme: 'http', host: stageHost, path: '/api/tasks-delete',queryParameters: queryParameters);
    final response = await client.delete(
      taskdeleteURL,
      headers: {
        'x-access-token': Token,
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      },
    );
    if (response.statusCode == 200) {
    } else {
      final Map result = json.decode(response.body);
      throw Exception(result["status"]);
    }
  }

//Subtask CRUD Functions
  //Get Subtasks
  Future<List<Subtask>> getSubtasks(Task task) async {
    final Token = await jwt.read_token();
    final queryParameters = {
      'taskKey':task.taskKey,
    };
    Uri subtaskURL = Uri(scheme: 'http', host: stageHost, path: '/api/subtasks-get',queryParameters: queryParameters);

    final response = await client.get(
      subtaskURL,
      headers: {
        'x-access-token': Token,
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      },

    );
    final Map result = json.decode(response.body);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      List<Subtask> subtasks = [];
      for (Map<String, dynamic> json_ in result["data"]) {
        try {
          Subtask subtask = Subtask.fromJson(json_);
          subtask.deadline = json_['due_date'] == null
              ? DateTime.now()
              : DateTime.parse(json_['due_date']);
          subtask.assignedTo =
              await getUsersAssignedToSubtask(subtask.subtaskKey);
          subtasks.add(subtask);
        } catch (Exception) {
          print(Exception);
        }
      }
      return subtasks;
    } else {
      // If that call was not successful, throw an error.
      throw Exception(result["status"]);
    }
  }

  //Add Subtask
  Future addSubtask(String taskKey, String subtaskName) async {
    final Token = await jwt.read_token();
    final response = await client.post(
      subtaskaddURL,
      headers: {
        'x-access-token': Token,
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS"},
      body: jsonEncode({
        'taskKey':taskKey,
        "title": subtaskName,
      }),
    );
    if (response.statusCode == 201) {
      await Future<void>.delayed(const Duration(milliseconds: 400));
    } else {
      final Map result = json.decode(response.body);
      throw Exception(result["status"]);
    }
  }

  //Update Subtask
  Future updateSubtask(Subtask subtask) async {
    final Token = await jwt.read_token();
    final response = await client.patch(
      subtaskupdateURL,
      headers: {
        'x-access-token': Token,
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS"},
      body: jsonEncode({
        "subtask_key":subtask.subtaskKey,
        "note": subtask.note,
        "completed": subtask.completed,
        "due_date": subtask.deadline.toIso8601String(),
        "priority":subtask.priority
      }),
    );
    if (response.statusCode == 200) {
    } else {
      final Map result = json.decode(response.body);
      throw Exception(result["status"]);
    }
  }

  //Delete Subtask
  Future deleteSubtask(String subtaskKey) async {
    final Token = await jwt.read_token();
    final queryParameters = {
      "subtask_key": subtaskKey,
    };
    Uri subtaskdeleteURL = Uri(scheme: 'http', host: stageHost, path: '/api/subtasks-delete',queryParameters: queryParameters);
    final response = await client.delete(
      subtaskdeleteURL,
      headers: {
        'x-access-token': Token,
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      },
        );
    if (response.statusCode == 200) {
    } else {
      final Map result = json.decode(response.body);
      throw Exception(result["status"]);
    }
  }

  //Search API Calls
  Future<List<GroupMember>> searchUser(String searchTerm) async {
    final Token = await jwt.read_token();
    print(searchTerm);
    final response = await client.post(
      searchURL,
      headers: {
        'x-access-token': Token,
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS"},
      body: jsonEncode({
        "search_term": searchTerm,
      }),
    );
    final Map result = json.decode(response.body);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      List<GroupMember> searchResults = [];
      print(result["data"]);
      for (Map<String, dynamic> json_ in result["data"]) {
        try {
          searchResults.add(GroupMember.fromJson(json_));
        } catch (Exception) {
          print(Exception);
          throw Exception;
        }
      }
      return searchResults;
    } else {
      // If that call was not successful, throw an error.
      throw Exception(result["status"]);
    }
  }

  ///AssignedToUser API Calls
  ///GET
  Future<List<GroupMember>> getUsersAssignedToSubtask(String subtaskKey) async {
    final Token = await jwt.read_token();
    final queryParameters = {
      "subtask_key": subtaskKey,};
    Uri assignedtouserhgetURL = Uri(scheme: 'http', host: stageHost, path: '/api/assignedtouserhURL-get', queryParameters: queryParameters);
    final response = await client.get(
      assignedtouserhgetURL,
      headers: {
        'x-access-token': Token,
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
    },
    );
    final Map result = json.decode(response.body);
    if (response.statusCode == 200) {
      List<GroupMember> groupMembers = [];
      for (Map<String, dynamic> json_ in result["data"]) {
        try {
          groupMembers.add(GroupMember.fromJson(json_));
        } catch (Exception) {
          print(Exception);
          //throw Exception;
        }
      }
      return groupMembers;
    } else {
      // If that call was not successful, throw an error.
      throw Exception(result["status"]);
    }
  }

  /// Post: Assign a Group Member to Subtask
  /// * SubtaskKey: Unique Subtask Identifier
  /// * Username: Group Member's Username to be added
  Future assignSubtaskToUser(String subtaskKey, String username) async {
    final Token = await jwt.read_token();
    final response = await client.post(
      assignedtouserhaddURL,
      headers: {
        'x-access-token': Token,
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        },
      body: jsonEncode({
        "subtask_key": subtaskKey,
        "username":username,
      }),

    );
    final Map result = json.decode(response.body);
    if (response.statusCode == 201) {
    } else {
      print(result["status"]);
      throw Exception(result["status"]);
    }
  }

  /// Delete: Unssign a Group Member to Subtask
  /// * SubtaskKey: Unique Subtask Identifier
  /// * Username: Group Member's Username to be added
  Future unassignSubtaskToUser(String subtaskKey, String username) async {
    final Token = await jwt.read_token();
    final queryParameters ={
      "subtask_key": subtaskKey,
    "username":username,
    };
    Uri assignedtouserhdeleteURL = Uri(scheme: 'http', host: stageHost, path: '/api/assignedtouserhURL-delete',queryParameters: queryParameters);
    final response = await client.delete(
      assignedtouserhdeleteURL,
      headers: {
        'x-access-token': Token,
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      },
    );
    if (response.statusCode == 200) {
    } else if (response.statusCode == 400 ||
        response.statusCode == 401 ||
        response.statusCode == 404) {
      final Map result = json.decode(response.body);
      throw Exception(result["status"]);
    }
  }

  Future send_message(String message,String sender,String subtaskKey) async{
    final Token = await jwt.read_token();
    final response = await client.post(
      sendmessage,
      headers: {
        'x-access-token': Token,
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      },
      body: jsonEncode({
        "message": message,
        "sender":sender,
        "subtaskKey":subtaskKey
      }),

    );
    final Map result = json.decode(response.body);
    if (response.statusCode == 201) {
    } else {
      print(result["status"]);
      throw Exception(result["status"]);
    }
  }

  Future<List<Message>> getMessages(String subtaskKey) async {
    final Token = await jwt.read_token();
    final queryParameters = {"subtask_key": subtaskKey};
    Uri messageURL = Uri(scheme: 'http', host: stageHost, path: '/api/message-get',queryParameters: queryParameters);
    final response = await client.get(
      messageURL,
      headers: {
        'x-access-token': Token,
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Credentials": 'true',
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      },
    );
    final Map result = json.decode(response.body);
    if (response.statusCode == 200) {
      List<Message> messages = [];
      for (Map<String, dynamic> json_ in result["data"]) {
        try {
          Message message = Message.fromJson(json_);
          messages.add(message);
        } catch (Exception) {
          print(Exception);
        }
      }
      return messages;
    } else {
      throw Exception(result["status"]);
    }
  }

}
