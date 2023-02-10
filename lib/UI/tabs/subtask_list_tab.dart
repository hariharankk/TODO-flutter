import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/UI/title_card.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/models/group.dart';
import 'package:todolist/models/subtasks.dart';
import 'package:todolist/models/tasks.dart';
import 'package:todolist/widgets/global_widgets/background_color_container.dart';
import 'package:todolist/widgets/task_widgets/add_subtask_widget.dart';
import 'package:todolist/widgets/task_widgets/subtask_list_item_widget.dart';
import 'package:todolist/widgets/task_widgets/priority.dart';
import 'package:todolist/bloc/resources/injection.dart';

class SubtaskListTab extends StatefulWidget {
  final Group group;
  final Task task;


  SubtaskListTab({required this.group, required this.task});

  @override
  _SubtaskListTabState createState() => _SubtaskListTabState();
}

class _SubtaskListTabState extends State<SubtaskListTab> {

  late SubtaskBloc subtaskBloc;
  late Group group;
  late Task task;
  late double unitHeightValue, unitWidthValue, height;
  late String orderBy;
  bool reorder;

  _SubtaskListTabState() : reorder = false {
    getOrderBy();
  }

  @override
  Widget build(BuildContext context) {
    task = widget.task;
    group = widget.group;
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size.width * 0.001;
    Size mediaQuery = MediaQuery.of(context).size;
    height = mediaQuery.height * 0.13;
    locator.registerLazySingleton<SubtaskBloc>(() =>SubtaskBloc(task));
    subtaskBloc = locator<SubtaskBloc>();
    return KeyboardSizeProvider(
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                task.title,
                style: appTitleStyle(unitHeightValue),
              ),
              centerTitle: true,
              backgroundColor: Colors.blue,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back,
                    size: 32.0 * unitHeightValue, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.white,
              ),
              actions: [
                PriorityPicker(onTap: (int value){
                  widget.task.priority = value;
                  locator<TaskBloc>().updateTask(widget.task);
                  setState(() {});
                } ),
                _popupMenuButton()
              ],
            ),
            body: Stack(
              children: <Widget>[
                BackgroundColorContainer(
                  startColor: Colors.white,
                  endColor: Colors.white,
                  widget:
                      TitleCard(title: 'பணிகள்', child: _buildStreamBuilder()),
                ),
                AddSubtask(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  StreamBuilder<List<Subtask>> _buildStreamBuilder() {
    return StreamBuilder(
      // Wrap our widget with a StreamBuilder
      stream: subtaskBloc.getSubtasks, // pass our Stream getter here
      initialData: task.subtasks, // provide an initial data
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            break;
          case ConnectionState.active:
            if (snapshot.hasData && !listEquals(task.subtasks, snapshot.data)) {
              task.subtasks = snapshot.data!;
            }
            if (reorder) {
              reorder = false;
            }
            return _buildList();
          case ConnectionState.waiting:
            return Center(
                child: CircularProgressIndicator(color: Colors.blue));
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget _buildList() {
    _orderBy();
    return Theme(
      data: ThemeData(canvasColor: Colors.transparent),
      key: UniqueKey(),
      child: ListView(
        key: UniqueKey(),
        padding: EdgeInsets.only(top: height + 40, bottom: 90),
        children: task.subtasks.map<Dismissible>((Subtask item) {
          return _buildListTile(item);
        }).toList(),
      ),
    );
  }

  Dismissible _buildListTile(Subtask subtask) {
    return Dismissible(
      key: Key(subtask.subtaskKey),
      child: ListTile(
        key: Key(subtask.title),
        title: SubtaskListItemWidget(
          subtask: subtask,
          group: group,
        ),
      ),
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.black,
          size: 28 * unitHeightValue,
        ),
      ),
      onDismissed: (direction) {
        deleteSubtask(subtask);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("பணி " + subtask.title + " நீக்கப்பட்டது"),
          action: SnackBarAction(
            label: 'செயல்தவிர்',
            onPressed: () {
              reAddSubtask(subtask);
            },
          ),
        ));
      },
      direction: DismissDirection.endToStart,
    );
  }



  void reAddSubtask(Subtask subtask) async {
    await subtaskBloc.addSubtask(subtask.title);
    setState(() {});
  }

  Future<Null> deleteSubtask(Subtask subtask) async {
    await subtaskBloc.deleteSubtask(subtask.subtaskKey);
    setState(() {});
  }

  PopupMenuButton _popupMenuButton() {
    return PopupMenuButton<String>(
      padding: EdgeInsets.symmetric(
          vertical: 8 * unitHeightValue, horizontal: 8 * unitWidthValue),
      icon: Icon(Icons.sort,
          size: 32.0 * unitHeightValue, color: Colors.white),
      color: Colors.white,
      tooltip: 'வகைபடுத்து',
      offset: Offset(0, 70 * unitHeightValue),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      onSelected: (value) {
        saveOrderBy(value);
        setState(() {
          reorder = true;
        });
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: "அகரவரிசைப்படி",
          child: Row(children: [
            Icon(Icons.sort_by_alpha, size: 24 * unitHeightValue, color: Colors.blue),
            SizedBox(width: 30.0 * unitWidthValue),
            Text(
              "அகரவரிசைப்படி",
              style: TextStyle(
                  color: Colors.blue, fontSize: 24 * unitHeightValue),
            )
          ]),
        ),
        PopupMenuItem<String>(
          value: "அண்மையில்-பழமையான",
          child: Row(children: [
            Icon(Icons.date_range, size: 24 * unitHeightValue,color: Colors.blue),
            SizedBox(width: 30.0 * unitWidthValue),
            Text(
              "அண்மையில்-பழமையான",
              style: TextStyle(
                  color: Colors.blue, fontSize: 24 * unitHeightValue),
            )
          ]),
        ),
        PopupMenuItem<String>(
          value: "பழமையான-அண்மையில்",
          child: Row(children: [
            Icon(Icons.date_range,color: Colors.blue,  size: 24 * unitHeightValue),
            SizedBox(width: 30.0 * unitWidthValue),
            Text(
              "பழமையான-அண்மையில்",
              style: TextStyle(
                  color: Colors.blue, fontSize: 24 * unitHeightValue),
            )
          ]),
        ),
        PopupMenuItem<String>(
          value: "இறுதி தேதி",
          child: Row(children: [
            Icon(Icons.date_range,color: Colors.blue, size: 24 * unitHeightValue),
            SizedBox(width: 30.0 * unitWidthValue),
            Text(
              "இறுதி தேதி",
              style: TextStyle(
                  color: Colors.blue, fontSize: 24 * unitHeightValue),
            )
          ]),
        ),
      ],
    );
  }

  _orderBy() {
    switch (orderBy) {
      case "அகரவரிசைப்படி":
        task.subtasks.sort(
            (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case "அண்மையில்-பழமையான":
        task.subtasks.sort((a, b) => b.timeCreated.compareTo(a.timeCreated));
        break;
      case "பழமையான-அண்மையில்":
        task.subtasks.sort((a, b) => a.timeCreated.compareTo(b.timeCreated));
        break;
      case "இறுதி தேதி":
        task.subtasks.sort((a, b) => a.deadline.compareTo(b.deadline));
        break;
      default:
    }
  }

  /// Get order list from persistant storage.
  void getOrderBy() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.orderBy = prefs.getString('SUBTASK_ORDER_LIST') ?? "பழமையான-அண்மையில்";
  }

  /// Save orderlist to Device's persistant storage
  Future<void> saveOrderBy(String orderBy) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('SUBTASK_ORDER_LIST', orderBy);
    this.orderBy = orderBy;
  }
}

class WorkerSubtaskListTab extends StatefulWidget {
  final Group group;
  final Task task;


  WorkerSubtaskListTab({required this.group, required this.task});

  @override
  _WorkerSubtaskListTabState createState() => _WorkerSubtaskListTabState();
}

class _WorkerSubtaskListTabState extends State<WorkerSubtaskListTab> {

  late SubtaskBloc subtaskBloc;
  late Group group;
  late Task task;
  late double unitHeightValue, unitWidthValue, height;
  late String orderBy;
  bool reorder;

  _WorkerSubtaskListTabState() : reorder = false {
    getOrderBy();
  }

  @override
  Widget build(BuildContext context) {
    task = widget.task;
    group = widget.group;
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size.width * 0.001;
    Size mediaQuery = MediaQuery.of(context).size;
    height = mediaQuery.height * 0.13;
    locator.registerLazySingleton<SubtaskBloc>(() =>SubtaskBloc(task));
    subtaskBloc = locator<SubtaskBloc>();
    return KeyboardSizeProvider(
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                task.title,
                style: appTitleStyle(unitHeightValue),
              ),
              centerTitle: true,
              backgroundColor: Colors.blue,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back,
                    size: 32.0 * unitHeightValue, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.white,
              ),
              actions: [
                PriorityPicker(onTap: (int value){
                  widget.task.priority = value;
                  locator<TaskBloc>().updateTask(widget.task);
                  setState(() {});
                } ),
                _popupMenuButton()
              ],
            ),
            body: Stack(
              children: <Widget>[
                BackgroundColorContainer(
                  startColor: Colors.white,
                  endColor: Colors.white,
                  widget:
                  TitleCard(title: 'பணிகள்', child: _buildStreamBuilder()),
                ),
                AddSubtask(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  StreamBuilder<List<Subtask>> _buildStreamBuilder() {
    return StreamBuilder(
      // Wrap our widget with a StreamBuilder
      stream: subtaskBloc.getSubtasks, // pass our Stream getter here
      initialData: task.subtasks, // provide an initial data
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            break;
          case ConnectionState.active:
            if (snapshot.hasData && !listEquals(task.subtasks, snapshot.data)) {
              task.subtasks = snapshot.data!;
            }
            if (reorder) {
              reorder = false;
            }
            return _buildList();
          case ConnectionState.waiting:
            return Center(
                child: CircularProgressIndicator(color: Colors.blue));
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget _buildList() {
    _orderBy();
    return Theme(
      data: ThemeData(canvasColor: Colors.transparent),
      key: UniqueKey(),
      child: ListView(
        key: UniqueKey(),
        padding: EdgeInsets.only(top: height + 40, bottom: 90),
        children: task.subtasks.map<ListTile>((Subtask item) {
          return _buildListTile(item);
        }).toList(),
      ),
    );
  }

  ListTile _buildListTile(Subtask subtask) {
    return ListTile(
      key: Key(subtask.title),
      title: WorkerSubtaskListItemWidget(
        subtask: subtask,
        group: group,
      ),
    );
  }

  PopupMenuButton _popupMenuButton() {
    return PopupMenuButton<String>(
      padding: EdgeInsets.symmetric(
          vertical: 8 * unitHeightValue, horizontal: 8 * unitWidthValue),
      tooltip: 'வகைபடுத்து',
      icon: Icon(Icons.sort,
          size: 32.0 * unitHeightValue, color: Colors.white),
      color: Colors.white,
      offset: Offset(0, 70 * unitHeightValue),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      onSelected: (value) {
        saveOrderBy(value);
        setState(() {
          reorder = true;
        });
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: "அகரவரிசைப்படி",
          child: Row(children: [
            Icon(Icons.sort_by_alpha, size: 24 * unitHeightValue, color: Colors.blue),
            SizedBox(width: 30.0 * unitWidthValue),
            Text(
              "அகரவரிசைப்படி",
              style: TextStyle(
                  color: Colors.blue, fontSize: 24 * unitHeightValue),
            )
          ]),
        ),
        PopupMenuItem<String>(
          value: "அண்மையில்-பழமையான",
          child: Row(children: [
            Icon(Icons.date_range, size: 24 * unitHeightValue,color: Colors.blue),
            SizedBox(width: 30.0 * unitWidthValue),
            Text(
              "அண்மையில்-பழமையான",
              style: TextStyle(
                  color: Colors.blue, fontSize: 24 * unitHeightValue),
            )
          ]),
        ),
        PopupMenuItem<String>(
          value: "பழமையான-அண்மையில்",
          child: Row(children: [
            Icon(Icons.date_range,color: Colors.blue,  size: 24 * unitHeightValue),
            SizedBox(width: 30.0 * unitWidthValue),
            Text(
              "பழமையான-அண்மையில்",
              style: TextStyle(
                  color: Colors.blue, fontSize: 24 * unitHeightValue),
            )
          ]),
        ),
        PopupMenuItem<String>(
          value: "இறுதி தேதி",
          child: Row(children: [
            Icon(Icons.date_range,color: Colors.blue, size: 24 * unitHeightValue),
            SizedBox(width: 30.0 * unitWidthValue),
            Text(
              "இறுதி தேதி",
              style: TextStyle(
                  color: Colors.blue, fontSize: 24 * unitHeightValue),
            )
          ]),
        ),
      ],
    );
  }

  _orderBy() {
    switch (orderBy) {
      case "அகரவரிசைப்படி":
        task.subtasks.sort(
                (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case "அண்மையில்-பழமையான":
        task.subtasks.sort((a, b) => b.timeCreated.compareTo(a.timeCreated));
        break;
      case "பழமையான-அண்மையில்":
        task.subtasks.sort((a, b) => a.timeCreated.compareTo(b.timeCreated));
        break;
      case "இறுதி தேதி":
        task.subtasks.sort((a, b) => a.deadline.compareTo(b.deadline));
        break;
      default:
    }
  }

  /// Get order list from persistant storage.
  void getOrderBy() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.orderBy = prefs.getString('SUBTASK_ORDER_LIST') ?? "பழமையான-அண்மையில்";
  }

  /// Save orderlist to Device's persistant storage
  Future<void> saveOrderBy(String orderBy) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('SUBTASK_ORDER_LIST', orderBy);
    this.orderBy = orderBy;
  }
}

class VisitorSubtaskListTab extends StatefulWidget {
  final Group group;
  final Task task;


  VisitorSubtaskListTab({required this.group, required this.task});

  @override
  _VisitorSubtaskListTabState createState() => _VisitorSubtaskListTabState();
}

class _VisitorSubtaskListTabState extends State<VisitorSubtaskListTab> {

  late SubtaskBloc subtaskBloc;
  late Group group;
  late Task task;
  late double unitHeightValue, unitWidthValue, height;
  late String orderBy;
  bool reorder;

  _VisitorSubtaskListTabState() : reorder = false {
    getOrderBy();
  }

  @override
  Widget build(BuildContext context) {
    task = widget.task;
    group = widget.group;
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size.width * 0.001;
    Size mediaQuery = MediaQuery.of(context).size;
    height = mediaQuery.height * 0.13;
    locator.registerLazySingleton<SubtaskBloc>(() =>SubtaskBloc(task));
    subtaskBloc = locator<SubtaskBloc>();
    return KeyboardSizeProvider(
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                task.title,
                style: appTitleStyle(unitHeightValue),
              ),
              centerTitle: true,
              backgroundColor: Colors.blue,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back,
                    size: 32.0 * unitHeightValue, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.white,
              ),
              actions: [
                _popupMenuButton()
              ],
            ),
            body: Stack(
              children: <Widget>[
                BackgroundColorContainer(
                  startColor: Colors.white,
                  endColor: Colors.white,
                  widget:
                  TitleCard(title: 'பணிகள்', child: _buildStreamBuilder()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  StreamBuilder<List<Subtask>> _buildStreamBuilder() {
    return StreamBuilder(
      // Wrap our widget with a StreamBuilder
      stream: subtaskBloc.getSubtasks, // pass our Stream getter here
      initialData: task.subtasks, // provide an initial data
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            break;
          case ConnectionState.active:
            if (snapshot.hasData && !listEquals(task.subtasks, snapshot.data)) {
              task.subtasks = snapshot.data!;
            }
            if (reorder) {
              reorder = false;
            }
            return _buildList();
          case ConnectionState.waiting:
            return Center(
                child: CircularProgressIndicator(color: Colors.blue));
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget _buildList() {
    _orderBy();
    return Theme(
      data: ThemeData(canvasColor: Colors.transparent),
      key: UniqueKey(),
      child: ListView(
        key: UniqueKey(),
        padding: EdgeInsets.only(top: height + 40, bottom: 90),
        children: task.subtasks.map<ListTile>((Subtask item) {
          return _buildListTile(item);
        }).toList(),
      ),
    );
  }

  ListTile _buildListTile(Subtask subtask) {
    return ListTile(
        key: Key(subtask.title),
        title: VisitorSubtaskListItemWidget(
          subtask: subtask,
          group: group,
        ),
      );
  }


  PopupMenuButton _popupMenuButton() {
    return PopupMenuButton<String>(
      padding: EdgeInsets.symmetric(
          vertical: 8 * unitHeightValue, horizontal: 8 * unitWidthValue),
      tooltip: 'வகைபடுத்து',
      icon: Icon(Icons.sort,
          size: 32.0 * unitHeightValue, color: Colors.white),
      color: Colors.white,
      offset: Offset(0, 70 * unitHeightValue),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      onSelected: (value) {
        saveOrderBy(value);
        setState(() {
          reorder = true;
        });
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: "அகரவரிசைப்படி",
          child: Row(children: [
            Icon(Icons.sort_by_alpha, size: 24 * unitHeightValue, color: Colors.blue),
            SizedBox(width: 30.0 * unitWidthValue),
            Text(
              "அகரவரிசைப்படி",
              style: TextStyle(
                  color: Colors.blue, fontSize: 24 * unitHeightValue),
            )
          ]),
        ),
        PopupMenuItem<String>(
          value: "அண்மையில்-பழமையான",
          child: Row(children: [
            Icon(Icons.date_range, size: 24 * unitHeightValue,color: Colors.blue),
            SizedBox(width: 30.0 * unitWidthValue),
            Text(
              "அண்மையில்-பழமையான",
              style: TextStyle(
                  color: Colors.blue, fontSize: 24 * unitHeightValue),
            )
          ]),
        ),
        PopupMenuItem<String>(
          value: "பழமையான-அண்மையில்",
          child: Row(children: [
            Icon(Icons.date_range,color: Colors.blue,  size: 24 * unitHeightValue),
            SizedBox(width: 30.0 * unitWidthValue),
            Text(
              "பழமையான-அண்மையில்",
              style: TextStyle(
                  color: Colors.blue, fontSize: 24 * unitHeightValue),
            )
          ]),
        ),
        PopupMenuItem<String>(
          value: "இறுதி தேதி",
          child: Row(children: [
            Icon(Icons.date_range,color: Colors.blue, size: 24 * unitHeightValue),
            SizedBox(width: 30.0 * unitWidthValue),
            Text(
              "இறுதி தேதி",
              style: TextStyle(
                  color: Colors.blue, fontSize: 24 * unitHeightValue),
            )
          ]),
        ),
      ],
    );
  }

  _orderBy() {
    switch (orderBy) {
      case "அகரவரிசைப்படி":
        task.subtasks.sort(
                (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case "அண்மையில்-பழமையான":
        task.subtasks.sort((a, b) => b.timeCreated.compareTo(a.timeCreated));
        break;
      case "பழமையான-அண்மையில்":
        task.subtasks.sort((a, b) => a.timeCreated.compareTo(b.timeCreated));
        break;
      case "இறுதி தேதி":
        task.subtasks.sort((a, b) => a.deadline.compareTo(b.deadline));
        break;
      default:
    }
  }

  /// Get order list from persistant storage.
  void getOrderBy() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.orderBy = prefs.getString('SUBTASK_ORDER_LIST') ?? "பழமையான-அண்மையில்";
  }

  /// Save orderlist to Device's persistant storage
  Future<void> saveOrderBy(String orderBy) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('SUBTASK_ORDER_LIST', orderBy);
    this.orderBy = orderBy;
  }
}


