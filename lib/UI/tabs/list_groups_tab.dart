import 'package:flutter/material.dart';
import 'package:todolist/UI/title_card.dart';
import 'package:todolist/widgets/global_widgets/background_color_container.dart';
import 'package:todolist/widgets/group_widgets/group_list_widget.dart';

class ListGroupsTab extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    double height = mediaQuery.height * 0.17;
    return Stack(children: [
      BackgroundColorContainer(
        startColor: Colors.white,
        endColor: Colors.white,
        widget: TitleCard(
            title: "குழுக்கள்",
            child: GroupList(top: height)),
      )
    ]);
  }
}
