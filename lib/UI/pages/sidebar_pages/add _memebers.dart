//import 'package:circular_check_box/circular_check_box.dart';
import  'package:flutter/material.dart';
import 'package:todolist/bloc/resources/repository.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/models/group.dart';
import 'package:todolist/models/groupmember.dart';
import 'package:todolist/widgets/global_widgets/background_color_container.dart';
import 'package:todolist/bloc/resources/injection.dart';

class AddMembersPage extends StatefulWidget {


  AddMembersPage({Key? key}) : super(key: key);

  @override
  _AddMembersPageState createState() => _AddMembersPageState();
}

class _AddMembersPageState extends State<AddMembersPage> {
  late Size size;
  late double unitHeightValue;
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  Group group = locator<Group>(instanceName: 'creategroup');
  List<GroupMember> searchResults = [];

  bool selected = false;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    size = MediaQuery.of(context).size;
    unitHeightValue = size.height * 0.001;
    return SafeArea(
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
            appBar: AppBar(
              title: _isSearching ? _buildSearchField() : _buildTitle(),
              backgroundColor: Colors.blue,
              centerTitle: true,
              elevation: 0.0,
              toolbarHeight: 100.0,
              actions: _buildActions(),
              iconTheme: IconThemeData(
                  color: Colors.white,
                  size: 32.0 * unitHeightValue,
                  opacity: 1.0),
              leading: _isSearching
                  ? IconButton(
                icon: Icon(Icons.keyboard_arrow_down,
                    size: 30 * unitHeightValue),
                onPressed: () => FocusScope.of(context).unfocus(),
              )
                  : BackButton(),
              automaticallyImplyLeading: true,
            ),
            backgroundColor: Colors.transparent,
            body: Stack(
              alignment: Alignment.center,
              children: [_buildColumnCard()],
            ),
          ),
        ),
      ),
    );
  }

  Text _buildTitle() {
    return Text(
      "உறுப்பினர்களைச் சேர்க்கவும்",
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 32.0 * unitHeightValue,
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "பயனர்களைத் தேடு...",
        border: InputBorder.none,
        hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 24.0 * unitHeightValue),
      ),
      style: TextStyle(
        color: Colors.white,
        fontSize: 24.0 * unitHeightValue,

      ),
      onChanged: (query) {
        if (query.length >= 2) {
          updateSearchQuery(query);
        }
      },
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon:
          Icon(Icons.clear, color: Colors.white, size: 30 * unitHeightValue),
          onPressed: () {
            Navigator.pop(context);
            _clearSearchQuery();
          },
        ),
      ];
    }
    return <Widget>[
      IconButton(
        icon: Icon(Icons.search, size: 30 * unitHeightValue),
        onPressed: _startSearch,
      ),
    ];
  }

  void _startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _clearSearchQuery));

    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) async{
    if (newQuery.isNotEmpty) {
      searchResults = await repository.searchUser(newQuery);
    }
    setState(() {});
  }


  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      searchResults = [];
      _isSearching = false;
    });
  }

  Column _buildColumnCard() {
    return Column(children: [
      Container(
          height: size.height * 0.12,
          width: size.width,
          padding: EdgeInsets.only(top: 20),
          child: _addedMembersListView()),
      _expandedCard(),
    ]);
  }

  ListView _addedMembersListView() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final member = group.members[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Dismissible(
            key: Key(member.username),
            direction: DismissDirection.down,
            onDismissed: (direction) async {
              setState(() {
                group.removeGroupMember(member);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("அகற்றப்பட்டது ${member.username}"),
                ),
              );
            },
            child: Column(
              children: [
                group.members[index]
                    .cAvatar(radius: 25, unitHeightValue: unitHeightValue),
                Text(
                  group.members[index].username,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
      itemCount: group.members.length,
    );
  }

  Expanded _expandedCard() {
    return Expanded(child: _containerMembers());
  }

  Container _containerMembers() {
    double containerHeight = size.height * 0.6;
    return Container(
      height: containerHeight,
      width: size.width,
      padding: EdgeInsets.only(left: 24.0, top: 18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(50.0),
        ),
      ),
      child: Stack(
        children: [
          Text(
            "பயனர்கள்",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
              fontSize: 30 * unitHeightValue,
            ),
          ),
          paddingList()
        ],
      ),
    );
  }

  Padding paddingList() {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: searchResultListView(),
    );
  }

  ListView searchResultListView() {
    return ListView.separated(
      itemBuilder: (context, index) => ListTile(
        leading: searchResults[index]
            .cAvatar(unitHeightValue: unitHeightValue, radius: 16),
        title: Text(
          "${searchResults[index].username}",
          style: TextStyle(fontSize: 20 * unitHeightValue),
        ),
        trailing: Checkbox(
            value: group.members.contains(searchResults[index]),
            checkColor: Colors.white,
            activeColor: Colors.blue,
            onChanged: (val) {
              if (group.members.contains(searchResults[index])) {
                //_deleteGroupMember(widget.group.groupKey,searchResults[index].username);
                this.setState(() {
                  group.removeGroupMember(searchResults[index]);
                });
              } else if (!group.members.contains(searchResults[index])) {
                // _addGroupMember(widget.group.groupKey,searchResults[index].username);
                this.setState(() {
                  group.addGroupMember(searchResults[index]);
                });
              }
            }),
      ),
      separatorBuilder: (context, index) => Divider(),
      itemCount: searchResults.length,
    );
  }


}
