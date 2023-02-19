import 'package:flutter/material.dart';
import 'package:todolist/models/global.dart';

class ListItems extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return
      Container(
        height: MediaQuery.of(context).size.height * 0.25,
        decoration: new BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                        Icons.arrow_back_outlined, color: Colors.blue
                    )),
                SizedBox(width: 2,),
                Text(
                  'குழு உறுப்பினரின் பங்கைத் தேர்ந்தெடுக்கவும்',
                  style: TextStyle(color: Colors.black, fontSize: 10,fontWeight: FontWeight.bold),
                ),

              ],
            ),
            Divider(color: Colors.black,),
            Expanded(
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
            ),
          ],
        ),
//        ),
      );
  }
}