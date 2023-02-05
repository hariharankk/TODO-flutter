import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/bloc/resources/repository.dart';
import 'package:todolist/models/group.dart';
import 'package:todolist/models/groupmember.dart';
import 'package:todolist/widgets/global_widgets/background_color_container.dart';
import 'package:todolist/widgets/global_widgets/custom_appbar.dart';
import 'package:todolist/bloc/resources/injection.dart';
import 'package:todolist/UI/pages/sidebar_pages/add _memebers.dart';
import 'package:todolist/models/global.dart';

class CreateGroupPage extends StatefulWidget {
  static const routeName = '/create_group';

  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  Group newGroup = locator<Group>(instanceName: 'creategroup');
  int membersLength = 0;
  bool isPrivate = true;
  TextEditingController groupName = new TextEditingController();
  late double unitHeightValue, unitWidthValue;
  bool saving = true;
  late GroupMember admin;

  @override
  void initState() {
    if (newGroup.members.length == 0) {
      admin=userBloc.getUserObject();
      admin.role='Admin';
      newGroup.addGroupMember(admin);
      membersLength = newGroup.members.length;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size  .width * 0.001;

    return saving ? SafeArea(
      child: BackgroundColorContainer(
        startColor: Colors.white,
        endColor: Colors.white,
        widget: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Scaffold(
            appBar: CustomAppBar(
              "",
              leading: GestureDetector(
                child: Icon(Icons.arrow_back_outlined,color: Colors.white,),
                onTap: ()=> Navigator.pop(context),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: saveGroup,
                  child: Text(
                    "Save",
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
      ),
    )
        : Center(child: CircularProgressIndicator(),);
  }

  void saveGroup() async {
    if (groupName.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Enter a Group Name"),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      setState(() {
        saving=false;
      });

      String groupKey = await repository.addGroup(groupName.text, isPrivate);
      for (GroupMember member in newGroup.members) {
        try {
          await repository.addGroupMember(groupKey, member.username,member.role);
        } catch (e) {
          print(e);
        }
      }
      await groupBloc.updateGroups();
      // locator.resetLazySingleton<Group>();
      Navigator.pop(context);
    }
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
      radius: 50.0 * unitHeightValue,
      backgroundColor: Colors.white,
      child: Icon(
        Icons.group,
        size: 62.0 * unitHeightValue,
        color: Colors.blue,
      ),
    );
  }

  Container _buildGroupNameContainer() {
    return Container(
      //margin: const EdgeInsets.only(left: 100.0, right: 45.0, bottom: 20.0),
      width: 480 * unitWidthValue,
      padding: EdgeInsets.only(left: 20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(25)),
      child: _buildGroupNameTF(),
    );
  }

  TextField _buildGroupNameTF() {
    return TextField(
      controller: groupName,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Group Name",
        hintStyle: TextStyle(
          color: Colors.black54,
          fontSize: 24 * unitHeightValue,
        ),
        suffixIcon: Icon(
          Icons.edit,
          color: Colors.black54,
          size: 24 * unitHeightValue,
        ),
        isDense: true,
      ),
      style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black54,
          fontSize: 30 * unitHeightValue),
      onChanged: (groupName) => newGroup.name = groupName,
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
        "MEMBERS",
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
          "${newGroup.members.length}",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16 * unitHeightValue,
          ),
        ),
      ),
      Spacer(),
      Text(
        "Public",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black54,
          fontSize: 20 * unitHeightValue,
        ),
      ),
      Switch(
          value: isPrivate,
          onChanged: (newValue) {
            setState(() {
              isPrivate = newValue;
            });
          }),
    ]);
  }

  Padding _buildMembersList() {
    newGroup.addListener(() {
      setState(() {
        membersLength = newGroup.members.length;
      });
    });
    return Padding(
      padding: EdgeInsets.only(
          top: 75.0 * unitHeightValue, right: 24.0 * unitWidthValue),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200 * unitWidthValue,
          childAspectRatio: 0.75,
          crossAxisSpacing: 10 * unitWidthValue,
          mainAxisSpacing: 10 * unitHeightValue,
        ),
        itemBuilder: (context, index) => Column(
          children: [


              GestureDetector(
                child: newGroup.members[index]
                    .cAvatar(radius: 34, unitHeightValue: unitHeightValue),
              onTap: (){
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) =>  ListItems()).then((value) {
                      setState(() {
                        newGroup.members[index].role=value.toString();
                       });
                   });
                },
              ),

            Text(
              newGroup.members[index].username,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16 * unitHeightValue,
              ),
            ),

            Text(
              newGroup.members[index].role == null?'Admin':newGroup.members[index].role,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16 * unitHeightValue,
              ),
            ),

          ],
        ),
        itemCount: membersLength,
      ),
    );
  }

  Widget _addMembers() {
    return !this.isPrivate
        ? SizedBox.shrink()
        : Align(
            alignment: Alignment(0.9, 0.9),
            child: FloatingActionButton(
              tooltip: "Search to Add Members",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddMembersPage(),
                  ),
                );
              },
              child: Icon(Icons.arrow_forward, size: 36 * unitHeightValue),
            ),
          );
  }
}

class ListItems extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return
      Container(
        height: MediaQuery.of(context).size.height * 0.22,
        decoration: new BoxDecoration(
          color: Colors.white,
        ),
          child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: popup_repeat.length,
              //controller: yourScrollController,
              separatorBuilder: (BuildContext context,int index) {
                return Divider(color: Colors.grey,);
              },
              itemBuilder: (BuildContext context,int index) {
                return ListTile(
                    title: Text(group_permissions[index],style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    trailing: Icon(Icons.arrow_forward_outlined,color: Colors.black,),
                    onTap: (){
                      Navigator.pop(context,group_permissions[index]);
                    }
                );
              }
          ),
//        ),
      );
  }
}