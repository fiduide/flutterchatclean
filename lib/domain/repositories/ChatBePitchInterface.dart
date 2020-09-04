import 'package:flutterchatapp/domain/entities/chatMessage.dart';

abstract class ChatBePitchInterface {

  Future<List<chatMessage>> getAllMessage();

  Future<bool> sendMessage(chatMessage addMessage);
}
