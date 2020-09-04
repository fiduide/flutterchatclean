import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutterchatapp/app/pages/chat/Chat_presenter.dart';
import 'package:flutterchatapp/domain/entities/chatMessage.dart';

class ChatController extends Controller {
   List<chatMessage> _message;
   List<chatMessage> get message => _message;
  final ChatPresenter chatPresenter;

  ChatController(messageRepo) : chatPresenter = ChatPresenter(messageRepo), super();


  @override
  void initListeners() {
    chatPresenter.getMessageOnNext = (List<chatMessage> message) {
      if (message == null) {
        ScaffoldState state = getState();
        state.showSnackBar(SnackBar(content: Text(
          'Chargement des messages, veuillez patienter...',
          style: TextStyle(color: Colors.white),),
            elevation: 8,
            backgroundColor: Colors.grey[600]));
        refreshUI();
      } else {
        _message = message;
        refreshUI();
      }
    };
    chatPresenter.getMessageOnComplete = () {
      print('Message retrieved');
    };

    chatPresenter.getMessageOnError = (e) {
      print('Je n\'arrive pas à récupérer vos messages');
      ScaffoldState state = getState();
      state.showSnackBar(SnackBar(content: Text(e.message)));
      _message = null;
      refreshUI();
    };

    chatPresenter.getMessageOnWaiting = () {};
  }

    void getMessage() => chatPresenter.getMessage();


    @override
    void onResumed(){
      print('en pause');
      super.onResumed();
    }

    @override
    void dispose(){
      chatPresenter.dispose();
      super.dispose();
    }

}
