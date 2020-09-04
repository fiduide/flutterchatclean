import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterchatapp/domain/entities/chatMessage.dart';
import '../../domain/repositories/ChatBePitchInterface.dart';
import 'package:mysql1/mysql1.dart';

class AdapteurMysql implements ChatBePitchInterface {

  Future<List<chatMessage>> getAllMessage() async {
    List<chatMessage> messageList = [];

    var settings = new ConnectionSettings(
      host: '35.228.59.79',
      port: 3306,
      user: 'root',
      password: '161100',
      db: 'testchat',
    );

    var connection = await MySqlConnection.connect(settings);

    Results results =
        await connection.query('SELECT * FROM chat ORDER BY date ASC');

    for (var table in results.toList()) {
      chatMessage query = new chatMessage();
      query.content = table[1].toString();
      query.date = table[2].toString();
      messageList.add(query);
    }
    return messageList;
  }

  Future<bool> sendMessage(chatMessage addMessage) async {
    var settings = new ConnectionSettings(
      host: '35.228.59.79',
      port: 3306,
      user: 'root',
      password: '161100',
      db: 'testchat',
    );

    var connection = await MySqlConnection.connect(settings);
    await connection.query(
        "INSERT INTO chat (message, date) VALUES (? , NOW())",
        [addMessage.content]).catchError((e) {
      print(e);
      return false;
    });
    return true;
  }
}
