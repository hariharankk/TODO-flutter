import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/models/group.dart';
import 'package:todolist/models/groupmember.dart';
import 'package:todolist/models/message.dart';
import 'package:todolist/models/subtasks.dart';
import 'package:todolist/models/tasks.dart';
import 'dart:convert';
import 'package:todolist/models/user.dart';

class ApiProvider {
  Client client = Client();
  //static String baseURL = "https://taskmanager-group-pro.herokuapp.com/api";
  //static Uri baseURL = 'https://taskmanager-group-stage.herokuapp.com/api';
  //static String baseURL = "http://10.0.2.2:5000/api";

  static String stageHost = 'b589-35-237-8-21.ngrok.io';
  static String productionHost = 'taskmanager-group-pro.herokuapp.com';
  static String localhost = "10.0.2.2:5000";
  Uri signinURL = Uri(scheme: 'http', host: stageHost, path: '/api/signin');
  Uri userURL = Uri(scheme: 'http', host: stageHost, path: '/api/user');
  Uri userupdateURL = Uri(scheme: 'http', host: stageHost, path: '/api/userupdate');

  Uri taskaddURL = Uri(scheme: 'http', host: stageHost, path: '/api/tasks-add');
  Uri taskupdateURL = Uri(scheme: 'http', host: stageHost, path: '/api/tasks-update');

  Uri subtaskaddURL = Uri(scheme: 'http', host: stageHost, path: '/api/subtasks-add');
  Uri subtaskupdateURL = Uri(scheme: 'http', host: stageHost, path: '/api/subtasks-update');

  Uri groupaddURL = Uri(scheme: 'http', host: stageHost, path: '/api/group-add');
  Uri groupupdateURL = Uri(scheme: 'http', host: stageHost, path: '/api/group-update');

  Uri groupmemberaddURL = Uri(scheme: 'http', host: stageHost, path: '/api/groupmember-add');

  Uri searchURL = Uri(scheme: 'http', host: stageHost, path: '/api/search');

  Uri assignedtouserhaddURL = Uri(scheme: 'http', host: stageHost, path: '/api/assignedtouserhURL-add');

  Uri sendmessage = Uri(scheme: 'http', host: stageHost, path: '/api/message_send');

  String apiKey = '';

  // User CRUD Functions
  /// Sign Up
  Future<User> registerUser(String username, String password, String email,
      String firstname, String lastname, String phonenumber, avatar) async {

    print(userURL);
    final response = await client.post(
      userURL,
        headers: {
          "Access-Control-Allow-Origin": "*", // Required for CORS support to work
          "Access-Control-Allow-Methods": "POST, OPTIONS"
        },
      body: jsonEncode({
        "emailaddress": email,
        "username": username,
        "password": password,
        "firstname": firstname,
        "lastname": lastname,
        "phonenumber": phonenumber,
        "avatar": avatar,
      }),
    );
    final Map result = json.decode(response.body);
    if (response.statusCode == 201) {
      // If the call to the server was successful, parse the JSON

      await saveApiKey(result["data"]["api_key"]);
      print((result["data"]['role']));
      return User.fromJson(result["data"]);
    } else {
      // If that call was not successful, throw an error.
      throw Exception(result["status"]);
    }
  }

  /// Sign User In using username and password or API_Key
  Future signinUser(String username, String password, String apiKey) async {
    final response = await client.post(
      signinURL,
      headers: {"Authorization": apiKey,
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS"
      },
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );
    final Map result = json.decode(response.body);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      await saveApiKey(result["data"]["api_key"]);
      await Future<void>.delayed(const Duration(milliseconds: 200));
      return User.fromJson(result["data"]);
    } else {
      // If that call was not successful, throw an error.
      throw Exception(result["status"]);
    }
  }

  /// Edit Profile


  /// Group CRUD Functions
  /// Get a list of the User's Groups
  Future<List<Group>> getUserGroups() async {
    final _apiKey = await getApiKey();
    final queryParameters = {'apiKey':apiKey};
    Uri groupURL = Uri(scheme: 'http', host: stageHost, path: '/api/group',queryParameters: queryParameters);
    List<Group> groups = [];
    if (_apiKey.isNotEmpty) {
      final response = await client.get(
        groupURL,
        headers: {
          "Access-Control-Allow-Origin": "*", // Required for CORS support to work
          "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
          "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        },
          );
      final Map result = json.decode(response.body);
      print('group ${result["data"]}');
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
        return groups;
      } else {
        // If that call was not successful, throw an error.
        throw Exception(result["status"]);
      }
    }
    return groups;
  }

  /// Add a Group
  Future addGroup(String groupName, bool isPublic) async {
    print(groupaddURL);
    final response = await client.post(
      groupaddURL,
      headers: {
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS"
      },
      body: jsonEncode({
        'apiKey':apiKey,
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
    final response = await client.patch(
      groupupdateURL,
      headers: {
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
    final queryParameters = {
      "group_key": groupKey,
    };
    Uri groupdeleteURL = Uri(scheme: 'http', host: stageHost, path: '/api/group-delete',queryParameters: queryParameters);
    final response = await client.delete(
      groupdeleteURL,
      headers: {
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
    final queryParameters = {
      "groupKey":groupKey,
    };
    Uri groupmemberURL = Uri(scheme: 'http', host: stageHost, path: '/api/groupmember-get',queryParameters: queryParameters);
    final response = await client.get(
      groupmemberURL,
      headers: {
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
    final response = await client.post(
      groupmemberaddURL,
      headers: {
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
    final queryParameters = {
      "groupKey":groupKey,
    "username": username,
    };
    Uri groupmemberdeleteURL = Uri(scheme: 'http', host: stageHost, path: '/api/groupmember-delete',queryParameters: queryParameters);
    final response = await client.delete(
      groupmemberdeleteURL,
      headers: {
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
    final queryParameters = {"group_key": groupKey};
    Uri taskURL = Uri(scheme: 'http', host: stageHost, path: '/api/tasks-get',queryParameters: queryParameters);
    final response = await client.get(
      taskURL,
      headers: {
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
    final response = await client.post(
      taskaddURL,
      headers: {
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
    final response = await client.patch(
      taskupdateURL,
      headers: {
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
    final queryParameters = {"task_key":taskKey};
    Uri taskdeleteURL = Uri(scheme: 'http', host: stageHost, path: '/api/tasks-delete',queryParameters: queryParameters);
    final response = await client.delete(
      taskdeleteURL,
      headers: {
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
    final queryParameters = {
      'taskKey':task.taskKey,
    };
    Uri subtaskURL = Uri(scheme: 'http', host: stageHost, path: '/api/subtasks-get',queryParameters: queryParameters);

    final response = await client.get(
      subtaskURL,
      headers: {
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
    final response = await client.post(
      subtaskaddURL,
      headers: {
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
    final response = await client.patch(
      subtaskupdateURL,
      headers: {
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
    final queryParameters = {
      "subtask_key": subtaskKey,
    };
    Uri subtaskdeleteURL = Uri(scheme: 'http', host: stageHost, path: '/api/subtasks-delete',queryParameters: queryParameters);
    final response = await client.delete(
      subtaskdeleteURL,
      headers: {
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
    final response = await client.post(
      searchURL,
      headers: {"Authorization": apiKey,
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
    final queryParameters = {
      "subtask_key": subtaskKey,};
    Uri assignedtouserhgetURL = Uri(scheme: 'http', host: stageHost, path: '/api/assignedtouserhURL-get', queryParameters: queryParameters);
    final response = await client.get(
      assignedtouserhgetURL,
      headers: {
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
    final response = await client.post(
      assignedtouserhaddURL,
      headers: {
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
    final queryParameters ={
      "subtask_key": subtaskKey,
    "username":username,
    };
    Uri assignedtouserhdeleteURL = Uri(scheme: 'http', host: stageHost, path: '/api/assignedtouserhURL-delete',queryParameters: queryParameters);
    final response = await client.delete(
      assignedtouserhdeleteURL,
      headers: {
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
    final response = await client.post(
      sendmessage,
      headers: {
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
    final queryParameters = {"subtask_key": subtaskKey};
    Uri messageURL = Uri(scheme: 'http', host: stageHost, path: '/api/message-get',queryParameters: queryParameters);
    final response = await client.get(
      messageURL,
      headers: {
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


  /// Save API key to Device's persistant storage
  Future<void> saveApiKey(String apiKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('API_Token', apiKey);
    this.apiKey = apiKey;
  }

  /// Get API Key from persistant storage.
  Future<String> getApiKey() async {
    //if(apiKey.isNotEmpty) return apiKey;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('API_Token') ?? "";
  }
}
