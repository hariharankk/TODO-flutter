import 'package:flutter/material.dart';
import 'package:todolist/UI/tabs/todo_tab.dart';
import 'package:todolist/UI/pages/sidebar_pages/group_info_page.dart';
import 'package:todolist/UI/title_card.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/widgets/global_widgets/background_color_container.dart';
import 'package:todolist/widgets/group_widgets/group_list_widget.dart';

class ListGroupsTab extends StatelessWidget {
  static const routeName = '/listGroupsTab';

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    double height = mediaQuery.height * 0.17;
    return Stack(children: [
      BackgroundColorContainer(
        startColor: Colors.white,
        endColor: Colors.white,
        widget: TitleCard(
            title: "Groups",
            child: GroupList(top: height)),
      )
    ]);
  }
}
