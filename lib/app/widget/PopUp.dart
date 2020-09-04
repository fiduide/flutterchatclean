import 'package:flutterchatapp/app/pages/chat/Chat_view.dart';
import 'package:flutter/material.dart';


class PopUpMessage {


  //Confirmation de l'envoie d'un message
   Future<bool> dialogConfirm (BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Message envoyé'),
            content: Text('Le message a bien été envoyé, cliquer sur l\'icône à gauche'),
            actions: <Widget>[
              FlatButton(onPressed: (){
                Navigator.of(context).pop();
              },
                  child: Text('OK'))
            ],
          );
        }
    );
  }


  //Confirmation du changement de database
   Future<bool> changeDatabaseConfirm (BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: Center(child: Text('base de donnée changée, veuillez rafraichir')),
            elevation: 8,
            actions: <Widget>[
              FlatButton(onPressed: (){
                Navigator.of(context).pop();
              },
                  child: Text('OK'))
            ],
          );
        }
    );
  }


  //Si message = NULL
   Future<bool> messageNull (BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            content: Text('Veuillez remplir la zone de text'),
            elevation: 8,
            actions: <Widget>[
              FlatButton(onPressed: (){
                Navigator.of(context).pop();
              },
                  child: Text('OK'))
            ],
          );
        }
    );
  }


}