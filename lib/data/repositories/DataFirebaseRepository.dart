import 'package:flutterchatapp/domain/entities/chatMessage.dart';
import '../../domain/repositories/ChatBePitchInterface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';


class AdapteurFirebase implements ChatBePitchInterface {

  Future<List<chatMessage>> getAllMessage() async{
    List<chatMessage> messageList = [];
    QuerySnapshot search = await Firestore.instance
        .collection('Chat')
        .orderBy('Time')
        .getDocuments();

    for (int i = 0; i < search.documents.length; i++) {
      chatMessage query = new chatMessage();
      query.content = search.documents[i]['Message'];
      query.date = search.documents[i]['Time'];
      messageList.add(query);
    }
    return messageList;
  }

  Future<bool> sendMessage(chatMessage addMessage) {
    Map<String, Object> addData = {
      'Message': addMessage.content,
      'Time':
          formatDate(DateTime.now(), [M, '-', d, '   ', HH, '.', nn, ':', ss])
    };
    Firestore.instance.collection('Chat').add(addData).catchError((e) {
      return false;
    });
  }
}
