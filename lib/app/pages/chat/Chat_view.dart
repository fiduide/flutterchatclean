import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter/material.dart';
import 'package:flutterchatapp/Factory/FactoryAll.dart';
import 'package:flutterchatapp/data/repositories/DataFirebaseRepository.dart';
import 'package:flutterchatapp/data/repositories/DataSQLRepository.dart';
import 'package:flutterchatapp/domain/repositories/ChatBePitchInterface.dart';
import 'package:flutterchatapp/app/pages/chat/Chat_controller.dart';
import '../../widget/PopUp.dart';
import 'package:flutterchatapp/domain/entities/chatMessage.dart';
import 'package:demoji/demoji.dart';
import '../menu/menu_view.dart';
import 'dart:async';


// Corps de L'app

class ChatPage extends View {
  @override
  State<StatefulWidget> createState() => ChatPageState();
}

class ChatPageState extends ViewState<ChatPage, ChatController> {

  ChatPageState() : super(ChatController(messageSource));

  final TextEditingController _textControl = new TextEditingController();
  final popUp = new PopUpMessage();

  chatMessage contentMessage = new chatMessage();
  String addMessage;
  static ChatBePitchInterface messageSource;


  @override
  Widget buildPage(){

    List<chatMessage> message = controller.message;

    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: Text(
          nameDatabase,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        leading:
        FlatButton(
            onPressed: (){
              backToHome();
            },
            child: Icon(Icons.arrow_back_ios)
        ),
        actions: <Widget>[
          FlatButton(
              child: Text('Change database',
                  style: TextStyle(fontSize: 15, color: Colors.grey[700])),
              onPressed: () {
                changeDatabase();
              }),
        ],
        centerTitle: true,
      ),
      body: Container(
      child: ListView.builder(
        itemCount: message?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            return new Card(
                color: Colors.grey[800],
                elevation: 8.0,
                margin: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                child: new ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[700],
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  title: new Text(message[index].content,
                      textAlign: TextAlign.end, style: TextStyle(fontSize: 18)),
                  subtitle: new Text(message[index].date,
                      textAlign: TextAlign.end, style: TextStyle(fontSize: 10.5)),
                ));
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          decoration: BoxDecoration(color: Theme.of(context).cardColor),
          child: _buildTextComponent(),
        ),
      ),
    );
  }


  //Send Message
  Widget _buildTextComponent() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        padding:
        EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                  controller: _textControl,
                  onChanged: (String message) {
                    contentMessage.content = message;
                  },
                  onSubmitted: (String message) {
                    if (contentMessage.content != "" &&
                        contentMessage.content != null) {
                      contentMessage.content = message;
                    } else {
                      popUp.messageNull(context);
                    }
                  },
                  decoration: InputDecoration.collapsed(
                      hintText: "Envoyer un message...")),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    handleSubmitted(contentMessage);
                    _textControl.clear();
                  }),
            )
          ],
        ),
      ),
    );
  }

Timer timer;

  void initState(){
    super.initState();
    controller.getMessage();
    addData();
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) => refresh());
  }

  void refresh(){
    setState(() {
     addData();
    });
  }

  void handleSubmitted(chatMessage contentMessage)  {
    messageSource.sendMessage(contentMessage);
    setState(() {
      addData();
    });
  }

  void addData() {
      setState(() {
        messageSource = (FactoryAll(database)).messageSource;
        controller.getMessage();
      });
  }


   static int database = 1;
   static String nameDatabase = 'Firebase ${Demoji.fire}';


  void changeDatabase(){
    int setDatabase;
    String setNameDatabase;

    if (database == 1)  {
      setDatabase = 0;
      setNameDatabase = 'SQL ${Demoji.cloud}';

      setState(() {
        database = setDatabase;
        nameDatabase = setNameDatabase;
        addData();
      });


    } else if (database == 0) {
      setDatabase = 1;
      setNameDatabase = 'Firebase ${Demoji.fire}';
      setState(() {
        database = setDatabase;
        nameDatabase = setNameDatabase;
        addData();
      });
    }
  }

  void backToHome() {
    Navigator.push(
        context, new MaterialPageRoute(builder: (BuildContext context) {
      return new Menu();
    }));
  }

}

