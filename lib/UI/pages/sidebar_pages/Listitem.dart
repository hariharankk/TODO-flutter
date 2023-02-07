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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: 2,),
                Text(
                  'Select role of group member',
                  style: TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Go back',
                      style: TextStyle(color: Colors.blue),
                    )),

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