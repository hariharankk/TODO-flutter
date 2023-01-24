import 'package:flutter/material.dart';
import 'package:todolist/UI/tabs/subtask_info/subtask_info_tab.dart';
import 'package:todolist/bloc/resources/repository.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/models/group.dart';
import 'package:todolist/models/subtasks.dart';
import 'package:todolist/widgets/task_widgets/priority box.dart';

class SubtaskListItemWidget extends StatefulWidget {
  final Subtask subtask;
  final Group group;

  SubtaskListItemWidget(
      {required this.subtask, required this.group});
  @override
  _SubtaskListItemWidgetState createState() => _SubtaskListItemWidgetState();
}

class _SubtaskListItemWidgetState extends State<SubtaskListItemWidget> {
  late double listItemWidth;
  late Size mediaQuery;
  late double listItemHeight;
  bool change = false;
  late double unitHeightValue, unitWidthValue;
  //
  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size.width * 0.001;
    mediaQuery = MediaQuery.of(context).size;
    listItemWidth = mediaQuery.width * 0.85;
    listItemHeight = mediaQuery.height * 0.13;

    return GestureDetector(
      key: UniqueKey(),
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return SubtaskInfo(
          subtask: widget.subtask,
          members: widget.group.members,
        );
      })),
      child: altTile(),
    );
  }

  Container altTile() {
    return Container(
      height: listItemHeight,
      width: listItemWidth,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(28),
          ),
          boxShadow: [
            new BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 15.0,
            ),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: listItemHeight,
            width: listItemWidth * 0.8,
            padding: EdgeInsets.only(left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  child: Checkbox(
                      value: widget.subtask.completed,
                      onChanged: (bool? newValue) {
                        setState(() {
                          widget.subtask.completed = newValue!;
                          repository.updateSubtask(widget.subtask);
                        });
                      }),
                ),
                Flexible(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.subtask.title,
                        style: toDoListTileStyle(unitHeightValue),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                      widget.subtask.note.isNotEmpty
                          ? Text(
                              widget.subtask.note,
                              style: toDoListTiletimeStyle(unitHeightValue),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 2,
                            )
                          : Text(
                              "No Notes",
                              style: toDoListTiletimeStyle(unitHeightValue)
                            ),
                      widget.subtask.assignedTo.length > 0
                          ? _buildAssignedMemberAvatars()
                          : Text(
                              "No Assigned Members",
                              style: toDoListTiletimeStyle(unitHeightValue),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 100 * unitWidthValue,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          Row(
          children: [
            Icon(Icons.calendar_today,
                color: Colors.blue, size: 20 * unitHeightValue),
            SizedBox(width: 5 * unitWidthValue),
            Text(
            "Due Date: ${widget.subtask.deadline.month}/${widget.subtask.deadline.day}/${widget.subtask.deadline.year}",
              style: TextStyle(color: Colors.blue),
             ),
          ],
        ),

             Padding(
                padding: const EdgeInsets.only(right: 50.0),
                child:
                box(index: widget.subtask.priority,height: unitHeightValue*boxlength,width: unitWidthValue*boxwidth,),
              ),

              Row(
                  children: <Widget>[
                    Icon(Icons.messenger_outlined,color: Colors.blue,),
                    SizedBox(width: 5 * unitWidthValue),
                    Text('1',style: TextStyle(color: Colors.blue,fontSize: 20 ),),
                  ],
                ),

            ],
          ),
        ],
      ),
    );
  }

  Row _buildAssignedMemberAvatars() {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      for (int i = 0; i < 7 && i < widget.subtask.assignedTo.length; i++)
        Padding(
          padding: EdgeInsets.only(
              top: 8.0 * unitHeightValue, right: 5.0 * unitWidthValue),
          child: widget.subtask.assignedTo[i]
              .cAvatar(radius: 18, unitHeightValue: unitHeightValue),
        )
    ]);
  }
}
