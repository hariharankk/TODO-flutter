import 'package:flutter/material.dart';
import 'package:todolist/UI/pages/sidebar_pages/create_new_group_page.dart';
import 'package:todolist/UI/tabs/list_groups_tab.dart';

import 'package:todolist/models/global.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double unitHeightValue, unitWidthValue;


  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size.width * 0.001;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("TODO List", style: appTitleStyle(unitHeightValue)),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(
                Icons.group_add,
                color: darkBlueGradient,
                size: 32 * unitHeightValue,

              ),
              tooltip: 'Add Group',
              onPressed: () {
                Navigator.pushNamed(context, CreateGroupPage.routeName);
              }, //will go to Create a group Page
            ),
            SizedBox(
              width: 10 * unitWidthValue,
            )
          ],
        ),
        body: Container(
          child: Stack(
            children: <Widget>[
              ListGroupsTab(),
            ],
          ),
        ),
      ),
    );
  }
}
