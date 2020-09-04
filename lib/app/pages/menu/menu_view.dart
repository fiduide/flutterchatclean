import 'package:demoji/demoji.dart';
import 'package:flutter/material.dart';
import 'package:flutterchatapp/app/pages/pictureList/picture_view.dart';
import 'package:flutterchatapp/app/pages/chat/Chat_controller.dart';
import 'package:flutterchatapp/app/pages/chat/Chat_view.dart';


class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'PictureApp',
      theme: ThemeData.dark(),
      home: new menuHome(),
    );
  }
}

class menuHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MenuHome();
  }
}


class _MenuHome extends State<menuHome> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
                 Card(
                   margin: EdgeInsets.only(bottom: 30),
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                     elevation: 8.0,
                     color: Colors.grey[750],
                     child: FlatButton(
                       padding: EdgeInsets.only(top: 20, bottom: 20, left: 55, right: 55),
                       onPressed: (){
                         chatApp();
                       },
                       child: Text('Chat   ${Demoji.pencil2}', style: TextStyle(fontSize: 30),),
                     )
                 ),
                 Card(
                     color: Colors.grey[750],
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                     elevation: 8.0,
                     child: FlatButton(
                       padding: EdgeInsets.only(top: 20, bottom: 20, left: 40, right: 40),
                       onPressed: (){
                         pictureApp();
                       },
                       child: Text('Picture  ${Demoji.paperclips}', style: TextStyle(fontSize: 30),),
                     )
                 ),
              ]))
            );
  }

  void chatApp() {
    Navigator.push(context,
        new MaterialPageRoute(builder: (BuildContext context) {
          return new ChatPage();
        }));
  }

  void pictureApp() {
    Navigator.push(context,
        new MaterialPageRoute(builder: (BuildContext context) {
          return new ListPic();
        }));
  }

}