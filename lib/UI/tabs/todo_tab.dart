import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/UI/title_card.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/models/group.dart';
import 'package:todolist/models/tasks.dart';
import 'package:todolist/widgets/global_widgets/background_color_container.dart';
import 'package:todolist/widgets/task_widgets/add_task_widget.dart';
import 'package:todolist/widgets/task_widgets/task_list_item_widget.dart';
import 'package:todolist/UI/pages/sidebar_pages/group_info_page.dart';
/// Argument that can be passed when navigating to ToDoTab
/// * group
class ToDoTab extends StatefulWidget {
  Group group;
  ToDoTab({required this.group});
  @override
  _ToDoTabState createState() => _ToDoTabState();
}

class _ToDoTabState extends State<ToDoTab> {
  late TaskBloc taskBloc;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late Group group;
  late double unitHeightValue, unitWidthValue;
  late String orderBy;
  bool reorder;
  double height = 175;

  _ToDoTabState() : reorder = false {
    getOrderBy();
  }

  @override
  Widget build(BuildContext context) {
    group = widget.group;
    taskBloc = TaskBloc(group.groupKey);
    Size mediaQuery = MediaQuery.of(context).size;
    height = mediaQuery.height * 0.13;
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size.width * 0.001;
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
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text(
                group.name,
                style: appTitleStyle(unitHeightValue),
              ),
              centerTitle: true,
              backgroundColor: Colors.blue,
              elevation: 0,
              leading: IconButton(
                tooltip: 'back',
                icon: Icon(Icons.arrow_back,
                    size: 32.0 * unitHeightValue, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.white,
              ),

              actions: [
                IconButton(
                        tooltip:  'Edit Group',
                        icon: Icon(
                            Icons.group_add_outlined,
                        size: 32.0 * unitHeightValue, color:Colors.white),
                        onPressed: () {
                                  Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => GroupInfoPage(group: widget.group)));
                                  },
                        color: Colors.white,
                ),
                _popupMenuButton(),
              ],
            ),
            body: Stack(
              children: <Widget>[
                BackgroundColorContainer(
                  startColor: Colors.white,
                  endColor: Colors.white,
                  widget: TitleCard(
                    title: 'Tasks',
                    child: _buildStreamBuilder(),
                  ),
                ),
                AddTask(
                  taskbloc: taskBloc,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  StreamBuilder<List<Task>> _buildStreamBuilder() {
    return StreamBuilder(
      key: UniqueKey(),
      // Wrap our widget with a StreamBuilder
      stream: taskBloc.getTasks, // pass our Stream getter here
      initialData: group.tasks, // provide an initial data
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            print("None Data");
            break;
          case ConnectionState.active:
            if (snapshot.hasData && !listEquals(group.tasks, snapshot.data)) {
              group.tasks = snapshot.data!;
            }
            if (reorder) {
              reorder = false;
            }
            return _buildList();
          case ConnectionState.waiting:
            return Center(
                child: CircularProgressIndicator(color: Colors.black54));
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
        children: group.tasks.map<Dismissible>((Task item) {
          return _buildListTile(item);
        }).toList(),
      ),
    );
  }

  Dismissible _buildListTile(Task item) {
    return Dismissible(
      key: Key(item.taskKey),
      child: ListTile(
        key: Key(item.title),
        title: TaskListItemWidget(
          taskbloc: taskBloc,
          group: group,
          task: item,
        ),
      ),
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.blue,
          size: 28 * unitHeightValue,
        ),
      ),
      onDismissed: (direction) async {
        await deleteTask(item);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Task " + item.title + " dismissed"),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                reAddTask(item);
              },
            ),
          ),
        );
      },
      direction: DismissDirection.endToStart,
    );
  }

  void reAddTask(Task task) async {
    await taskBloc.addTask(task.title).then((value) {
      setState(() {});
    });
  }

  Future<Null> deleteTask(Task task) async {
    await taskBloc.deleteTask(task.taskKey).then((value) {
      setState(() {});
    });
  }

  PopupMenuButton _popupMenuButton() {
    return PopupMenuButton<String>(
      padding: EdgeInsets.symmetric(
          vertical: 8 * unitHeightValue, horizontal: 8 * unitWidthValue),
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
          value: "Alphabetical",
          child: Row(children: [
            Icon(Icons.sort_by_alpha,color: Colors.blue, size: 24 * unitHeightValue),
            SizedBox(width: 30.0 * unitWidthValue),
            Text(
              "Alphabetical",
              style: TextStyle(
                  color: Colors.blue, fontSize: 24 * unitHeightValue),
            )
          ]),
        ),
        PopupMenuItem<String>(
          value: "Recent-Oldest",
          child: Row(children: [
            Icon(Icons.date_range, size: 24 * unitHeightValue,color: Colors.blue),
            SizedBox(width: 30.0 * unitWidthValue),
            Text(
              "Recent-Oldest",
              style: TextStyle(
                  color: Colors.blue, fontSize: 24 * unitHeightValue),
            )
          ]),
        ),
        PopupMenuItem<String>(
          value: "Oldest-Recent",
          child: Row(children: [
            Icon(Icons.date_range, size: 24 * unitHeightValue,color: Colors.blue),
            SizedBox(width: 30.0 * unitWidthValue),
            Text(
              "Oldest-Recent",
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
      case "Alphabetical":
        group.tasks.sort(
            (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case "Recent-Oldest":
        group.tasks.sort((a, b) => b.timeCreated.compareTo(a.timeCreated));
        break;
      case "Oldest-Recent":
        group.tasks.sort((a, b) => a.timeCreated.compareTo(b.timeCreated));
        break;
      default:
    }
  }

  /// Get order list from persistant storage.
  void getOrderBy() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.orderBy = prefs.getString('TASK_ORDER_LIST') ?? "Recent-Oldest";
  }

  /// Save orderlist to Device's persistant storage
  Future<void> saveOrderBy(String orderBy) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('TASK_ORDER_LIST', orderBy);
    this.orderBy = orderBy;
  }
}


