import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/models/group.dart';
import 'package:todolist/models/groupmember.dart';
import 'package:todolist/models/subtasks.dart';
import 'package:todolist/models/tasks.dart';
import 'dart:convert';
import 'package:todolist/models/user.dart';

class ApiProvider {
  Client client = Client();
  //static String baseURL = "https://taskmanager-group-pro.herokuapp.com/api";
  //static Uri baseURL = 'https://taskmanager-group-stage.herokuapp.com/api';
  //static String baseURL = "http://10.0.2.2:5000/api";

  static String stageHost = 'ee64-34-121-255-162.ngrok.io';
  static String productionHost = 'taskmanager-group-pro.herokuapp.com';
  static String localhost = "10.0.2.2:5000";
  Uri signinURL = Uri(scheme: 'http', host: stageHost, path: '/api/signin');
  Uri userURL = Uri(scheme: 'http', host: stageHost, path: '/api/user');
  Uri userupdateURL = Uri(scheme: 'http', host: stageHost, path: '/api/userupdate');

  Uri taskURL = Uri(scheme: 'http', host: stageHost, path: '/api/tasks-get');
  Uri taskaddURL = Uri(scheme: 'http', host: stageHost, path: '/api/tasks-add');
  Uri taskdeleteURL = Uri(scheme: 'http', host: stageHost, path: '/api/tasks-delete');
  Uri taskupdateURL = Uri(scheme: 'http', host: stageHost, path: '/api/tasks-update');

  Uri subtaskURL = Uri(scheme: 'http', host: stageHost, path: '/api/subtasks-get');
  Uri subtaskaddURL = Uri(scheme: 'http', host: stageHost, path: '/api/subtasks-add');
  Uri subtaskdeleteURL = Uri(scheme: 'http', host: stageHost, path: '/api/subtasks-delete');
  Uri subtaskupdateURL = Uri(scheme: 'http', host: stageHost, path: '/api/subtasks-update');

  Uri groupURL = Uri(scheme: 'http', host: stageHost, path: '/api/group');
  Uri groupaddURL = Uri(scheme: 'http', host: stageHost, path: '/api/group-add');
  Uri groupupdateURL = Uri(scheme: 'http', host: stageHost, path: '/api/group-update');
  Uri groupdeleteURL = Uri(scheme: 'http', host: stageHost, path: '/api/group-delete');

  Uri groupmemberURL = Uri(scheme: 'http', host: stageHost, path: '/api/groupmember-get');
  Uri groupmemberdeleteURL = Uri(scheme: 'http', host: stageHost, path: '/api/groupmember-delete');
  Uri groupmemberaddURL = Uri(scheme: 'http', host: stageHost, path: '/api/groupmember-add');

  Uri searchURL = Uri(scheme: 'http', host: stageHost, path: '/api/search');

  Uri assignedtouserhaddURL = Uri(scheme: 'http', host: stageHost, path: '/api/assignedtouserhURL-add');
  Uri assignedtouserhdeleteURL = Uri(scheme: 'http', host: stageHost, path: '/api/assignedtouserhURL-delete');
  Uri assignedtouserhgetURL = Uri(scheme: 'http', host: stageHost, path: '/api/assignedtouserhURL-get');

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
  Future updateUserProfile(
      String currentPassword,
      String newPassword,
      String email,
      String username,
      String firstname,
      String lastname,
      String phonenumber,
      avatar) async {
    final response = await client.post(
      userupdateURL,
      headers: {"Authorization": apiKey,
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS"
      },
      body: jsonEncode({
        "currentPassword": currentPassword,
        "newPassword": newPassword,
        "email": email,
        "username": username,
        "firstname": firstname,
        "lastname": lastname,
        "phonenumber": phonenumber,
        "avatar": avatar,
      }),
    );
    final Map result = json.decode(response.body);
    if (response.statusCode == 200) {
      //print("User Profile Updated");
      return User.fromJson(result["data"]);
    } else {
      // If that call was not successful, throw an error.
      print(json.decode(response.body));
      throw Exception(result["status"]);
    }
  }

  /// Group CRUD Functions
  /// Get a list of the User's Groups
  Future<List<Group>> getUserGroups() async {
    final _apiKey = await getApiKey();

    List<Group> groups = [];
    if (_apiKey.isNotEmpty) {
      final response = await client.get(
        groupURL,
        headers: {
          "Authorization": _apiKey,
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
            //print("Get User Groups: ${group.groupKey}");
            group.members = await getGroupMembers(group.groupKey);
            //print("--------------End members-------------");
            //group.tasks = await getTasks(group.groupKey);
            //print("--------------End tasks-------------");
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
      headers: {"Authorization": apiKey,
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS"
      },
      body: jsonEncode({
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
    final response = await client.post(
      groupupdateURL,
      headers: {"Authorization": group.groupKey,
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS"},
      body: jsonEncode({"name": group.name, "is_public": group.isPublic}),
    );
    final Map result = json.decode(response.body);
    if (response.statusCode == 200) {
      return true;
      //print("Task ${task.title} Updated");
    } else {
      // If that call was not successful, throw an error.
      throw Exception(result["status"]);
    }
  }

  /// Delete a Group
  Future deleteGroup(String groupKey) async {
    final response = await client.get(
      groupdeleteURL,
      headers: {"Authorization": groupKey,
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "GET, OPTIONS"},
    );
    if (response.statusCode == 200) {
      // If the call to the server was successful
      //print("Group deleted");
    } else {
      // If that call was not successful, throw an error.
      final Map result = json.decode(response.body);
      throw Exception(result["status"]);
    }
  }

// GroupMember CRUD Functions
  /// Get a list of the Group's Members.
  Future<List<GroupMember>> getGroupMembers(String groupKey) async {
    final response = await client.get(
      groupmemberURL,
      headers: {"Authorization": groupKey,
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
          groupMembers.add(GroupMember.fromJson(json_));
        } catch (Exception) {
          print(Exception);
          //throw Exception;
        }
      }
      //print("getGroupMembers: " +groupMembers.toString() +" @" +DateTime.now().toString());
      return groupMembers;
    } else {
      // If that call was not successful, throw an error.
      throw Exception(result["status"]);
    }
  }

  /// Add a Group Member to the Group.
  /// * GroupKey: Unique Group Identifier
  /// * Username: Group Member's Username to be added
  Future addGroupMember(String groupKey, String username) async {
    //print(groupmemberURL);
    final response = await client.post(
      groupmemberaddURL,
      headers: {"Authorization": groupKey,
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS"},
      body: jsonEncode({
        "username": username,
      }),
    );
    final Map result = json.decode(response.body);
    if (response.statusCode == 200) {
      GroupMember addedGroupMember = GroupMember.fromJson(result["data"]);
      print("User ${addedGroupMember.username} added to GroupKey: $groupKey");
    } else {
      // If that call was not successful, throw an error.
      print(result["status"]);
      throw Exception(result["status"]);
    }
  }

  /// Delete a Group Member
  /// * GroupKey: Unique Group Identifier
  /// * Username: Group Member's Username to be added
  Future deleteGroupMember(String groupKey, String username) async {
    Uri gmURLQuery = groupmemberdeleteURL.replace(query: "username=$username");
    print(gmURLQuery.toString());
    final response = await client.get(
      gmURLQuery,
      headers: {"Authorization": groupKey,
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "GET, OPTIONS"},
    );
    if (response.statusCode == 200) {
      // If the call to the server was successful
      //print("Group Member $username deleted");
    } else if (response.statusCode == 400 ||
        response.statusCode == 401 ||
        response.statusCode == 404) {
      // If that call was not successful, throw an error.
      final Map result = json.decode(response.body);
      throw Exception(result["status"]);
    }
  }

//Task CRUD Functions
  /// Get a list of the Group's Tasks
  /// * GroupKey: Unique group identifier
  Future<List<Task>> getTasks(String groupKey) async {
    //print("$groupKey");
    final response = await client.get(
      taskURL,
      headers: {"Authorization": groupKey,
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      },
    );
    final Map result = json.decode(response.body);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      List<Task> tasks = [];
      for (Map<String, dynamic> json_ in result["data"]) {
        try {
          Task task = Task.fromJson(json_);
          //task.subtasks = await getSubtasks(task.taskKey);
          tasks.add(task);
        } catch (Exception) {
          print(Exception);
        }
      }
      //print("getTasks: " + tasks.toString() + " @" + DateTime.now().toString());
      return tasks;
    } else {
      // If that call was not successful, throw an error.
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
      headers: {"Authorization": apiKey,
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS"},
      body: jsonEncode({"title": taskName, "group_key": groupKey}),
    );
    if (response.statusCode == 201) {
      //print("Task " + taskName + " added @" + DateTime.now().toString());
    } else {
      // If that call was not successful, throw an error.
      final Map result = json.decode(response.body);
      print(result["status"]);
      throw Exception(result["status"]);
    }
  }

  /// Update Task Info
  Future updateTask(Task task) async {
    final response = await client.post(
      taskupdateURL,
      headers: {"Authorization": task.taskKey,
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS"},
      body: jsonEncode({"completed": task.completed,
                                "priority":task.priority}),
    );
    if (response.statusCode == 200) {
      //print("Task ${task.title} Updated");
    } else {
      // If that call was not successful, throw an error.
      print(json.decode(response.body));
      throw Exception('Failed to update tasks');
    }
  }

  /// Delete Task from the Group's List of tasks
  /// * Task Key: Unique Task Identifier
  Future deleteTask(String taskKey) async {
    final response = await client.get(
      taskdeleteURL,
      headers: {"Authorization": taskKey,
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      },
    );
    if (response.statusCode == 200) {
      // If the call to the server was successful
      //print("Task deleted @" + DateTime.now().toString());
    } else {
      // If that call was not successful, throw an error.
      final Map result = json.decode(response.body);
      throw Exception(result["status"]);
    }
  }

//Subtask CRUD Functions
  //Get Subtasks
  Future<List<Subtask>> getSubtasks(Task task) async {
    final response = await client.get(
      subtaskURL,
      headers: {"Authorization": task.taskKey,
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
      headers: {"Authorization": taskKey,
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS"},
      body: jsonEncode({
        "title": subtaskName,
      }),
    );
    if (response.statusCode == 201) {
      await Future<void>.delayed(const Duration(milliseconds: 400));
      //print("Subtask " + subtaskName + " added @" + DateTime.now().toString());
    } else {
      print(response.statusCode);
      // If that call was not successful, throw an error.
      final Map result = json.decode(response.body);
      throw Exception(result["status"]);
    }
  }

  //Update Subtask
  Future updateSubtask(Subtask subtask) async {
    final response = await client.post(
      subtaskupdateURL,
      headers: {"Authorization": subtask.subtaskKey,
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS"},
      body: jsonEncode({
        "note": subtask.note,
        "completed": subtask.completed,
        "due_date": subtask.deadline.toIso8601String()
      }),
    );
    if (response.statusCode == 200) {
      print("Subtask " + subtask.title + " Updated");
    } else {
      // If that call was not successful, throw an error.
      final Map result = json.decode(response.body);
      throw Exception(result["status"]);
    }
  }

  //Delete Subtask
  Future deleteSubtask(String subtaskKey) async {
    final response = await client.get(
      subtaskdeleteURL,
      headers: {"Authorization": subtaskKey,
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      },
    );
    if (response.statusCode == 200) {
      // If the call to the server was successful
      //print("Subtask deleted @" + DateTime.now().toString());
    } else {
      // If that call was not successful, throw an error.
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
    final response = await client.get(
      assignedtouserhgetURL,
      headers: {"Authorization": subtaskKey,
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
          groupMembers.add(GroupMember.fromJson(json_));
        } catch (Exception) {
          print(Exception);
          //throw Exception;
        }
      }
      //print("getGroupMembers: " +groupMembers.toString() +" @" +DateTime.now().toString());
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
    Uri assignURLQuery =
        assignedtouserhaddURL.replace(query: "username=$username");
    final response = await client.get(
      assignURLQuery,
      headers: {"Authorization": subtaskKey,
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        },
    );
    final Map result = json.decode(response.body);
    if (response.statusCode == 201) {
      print(
          "User ${GroupMember.fromJson(result["data"]).username} assigned to SubtaskKey: $subtaskKey");
    } else {
      // If that call was not successful, throw an error.
      print(result["status"]);
      throw Exception(result["status"]);
    }
  }

  /// Delete: Unssign a Group Member to Subtask
  /// * SubtaskKey: Unique Subtask Identifier
  /// * Username: Group Member's Username to be added
  Future unassignSubtaskToUser(String subtaskKey, String username) async {
    Uri assignURLQuery =
        assignedtouserhdeleteURL.replace(query: "username=$username");
    final response = await client.get(
      assignURLQuery,
      headers: {"Authorization": subtaskKey,
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      },
    );
    if (response.statusCode == 200) {
      // If the call to the server was successful
      //print("Group Member $username deleted");
    } else if (response.statusCode == 400 ||
        response.statusCode == 401 ||
        response.statusCode == 404) {
      // If that call was not successful, throw an error.
      final Map result = json.decode(response.body);
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
