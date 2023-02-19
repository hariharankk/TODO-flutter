import 'package:flutter/material.dart';
import 'package:todolist/UI/pages/sidebar_pages/add_members.dart';
import 'package:todolist/bloc/resources/repository.dart';
import 'package:todolist/UI/pages/sidebar_pages/Listitem.dart';
import 'package:todolist/models/group.dart';
import 'package:todolist/models/groupmember.dart';
import 'package:todolist/widgets/global_widgets/background_color_container.dart';
import 'package:todolist/widgets/global_widgets/custom_appbar.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';

class GroupInfoPage extends StatefulWidget {
  Group group;
  GroupInfoPage({required this.group});
  @override
  _GroupInfoPageState createState() => _GroupInfoPageState();
}

class _GroupInfoPageState extends State<GroupInfoPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late Group group;
  late List<GroupMember> initialMembers;
  List<GroupMember> updatedMembers=[];
  late int membersLength;
  late double unitHeightValue, unitWidthValue;
  bool saving = true;

  @override
  void initState(){
    super.initState();
    group = widget.group;
    initialMembers = [...widget.group.members];
    membersLength = initialMembers.length;
  }
  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size.width * 0.001;
    return saving ?SafeArea(
      child: BackgroundColorContainer(
        startColor: Colors.white,
        endColor: Colors.white,
        widget: Scaffold(
          key: _scaffoldKey,
          appBar: CustomAppBar(
            '',
            leading: GestureDetector(
              child: Icon(Icons.arrow_back_outlined,color: Colors.white,),
              onTap: ()=> Navigator.pop(context),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: updateGroup,
                child: Text(
                  "தரவு புதுப்பிக்கவும்",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20 * unitHeightValue,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
            fontSize: 24 * unitHeightValue,
          ),
          backgroundColor: Colors.blue,
          body: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: _buildStack(),
          ),
        ),
      ),
    ): Container(
        color:Colors.white,
        child: Center(child: CircularProgressIndicator(),));
  }

   void updateGroup() async {
    String groupKey = group.groupKey;
    setState(() {
      saving=false;
    });
    for (GroupMember member in initialMembers) {
      if (!group.members.contains(member)) {
        try {
          await repository.deleteGroupMember(groupKey, member.username);
        } catch (e) {
          throw e;
        }
      }
    }
    //add to members
    for (GroupMember member in group.members) {
      if (!initialMembers.contains(member)) {
        try {
          await repository.addGroupMember(groupKey, member.username,member.role);
        } catch (e) {
          throw e;
        }
      }
    }

    for (GroupMember member in updatedMembers){
      try {
        await repository.updateGroupMemberrole(groupKey, member.username,member.role);
      } catch (e) {
        throw e;
      }
    }

    await groupBloc.updateGroups();
    Navigator.pop(context);
  }

  Stack _buildStack() {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        _buildColumn(),
      ],
    );
  }

  Column _buildColumn() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildAvatar(),
        SizedBox(height: 10 * unitHeightValue),
        _buildGroupNameContainer(),
        SizedBox(height: 20 * unitHeightValue),
        _buildExpandedCard(),
      ],
    );
  }

  CircleAvatar _buildAvatar() {
    return CircleAvatar(
      radius: 50.0,
      backgroundColor: Colors.white,
      child: Icon(
        Icons.group,
        color: Colors.blue,
        size: 62.0,
      ),
    );
  }

  Container _buildGroupNameContainer() {
    return Container(
      width: double.infinity,
      alignment: Alignment.topCenter,
      child: Text(
        group.name,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 30 * unitHeightValue,
        ),
      ),
    );
  }

  Expanded _buildExpandedCard() {
    return Expanded(
      child: _buildMembersContainer(),
    );
  }

  Container _buildMembersContainer() {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(left: 24.0, top: 18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(50.0),
        ),
      ),
      child: Stack(
        children: [_buildMembersLabelRow(), _buildMembersList(), _addMembers()],
      ),
    );
  }

  Row _buildMembersLabelRow() {
    return Row(children: [
      Text(
        "உறுப்பினர்கள்",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blue,
          fontSize: 22 * unitHeightValue,
        ),
      ),
      SizedBox(width: 15 * unitWidthValue),
      CircleAvatar(
        radius: 16 * unitHeightValue,
        backgroundColor: Colors.blue,
        child: Text(
          "${group.members.length}",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16 * unitHeightValue,
          ),
        ),
      ),
      Spacer(),
      Text(
        "பொது",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black54,
          fontSize: 20 * unitHeightValue,
        ),
      ),
      Switch(
          value: group.isPublic,
          onChanged: (newValue) {
            if (!group.isPublic || group.members.length == 1) {
              setState(
                () {
                  group.isPublic = newValue;
                  repository.updateGroup(group).catchError(
                    (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text("$e")));
                    },
                  );
                },
              );
            }
            if (group.members.length > 1) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("தனிப்பட்ட குழுக்கள் 1 உறுப்பினருக்கு மட்டுமே"),
                ),
              );
            }
          }),
    ]);
  }

  Padding _buildMembersList() {
    group.addListener(() {
      if (this.mounted) {
      setState(() {});
      }
    });
    return Padding(
      padding: EdgeInsets.only(top: 75.0*unitHeightValue, right: 24.0*unitWidthValue),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200 * unitWidthValue,
          childAspectRatio: 0.75,
          crossAxisSpacing: 30 * unitWidthValue,
          mainAxisSpacing: 30 * unitHeightValue,),
        itemBuilder: (context, index) => Column(
          children: [
            group.members[index].role == ''?
            GestureDetector(
              child: group.members[index]
                  .cAvatar(radius: 34, unitHeightValue: unitHeightValue),
              onTap: (){
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) =>  ListItems()).then((value) {
                  setState(() {
                    if(value!=null  ){
                      group.members[index].role=value.toString();
                    }

                  });
                });
              },

            ):
         GestureDetector(
           child: group.members[index]
        .cAvatar(radius: 34, unitHeightValue: unitHeightValue),
           onTap: (){
             showModalBottomSheet(
                 context: context,
                 isScrollControlled: true,
                 builder: (context) =>  ListItems()).then((value) {
               setState(() {
                 if(value!=null  ){
                   group.members[index].role=value.toString();
                   updatedMembers.add(group.members[index]);
                 }

               });
             });
           },

         ),
            Text(
              group.members[index].username,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Segoe ui',
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              group.members[index].role,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10 * unitHeightValue,
              ),
            ),

          ],
        ),
        itemCount: group.members.length,
      ),
    );
  }

  Widget _addMembers() {
    return this.group.isPublic
        ? Align(
            alignment: Alignment(0.9, 0.9),
            child: FloatingActionButton(
              tooltip: "உறுப்பினர்களைச் சேர்க்க தேடவும்",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddMembersPage(
                      group: group,
                    ),
                  ),
                );
              },
              child: Icon(Icons.arrow_forward, size: 36),
            ),
          )
        : SizedBox.shrink();
  }
}

