import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'dart:async';
import 'package:flutterchatapp/domain/entities/chatMessage.dart';
import 'package:flutterchatapp/domain/repositories/ChatBePitchInterface.dart';


class GetMessageUseCase extends UseCase<GetMessageUseCaseResponse, GetMessageParams> {

  ChatBePitchInterface messageSource;
  GetMessageUseCase([this.messageSource]);

  @override
  Future<Stream<GetMessageUseCaseResponse>> buildUseCaseStream(GetMessageParams params) async {

    StreamController messageController = StreamController <GetMessageUseCaseResponse>();

    try {
      //get Message
     List<chatMessage> message = await messageSource.getAllMessage();
     messageController.add(GetMessageUseCaseResponse(message));
      logger.finest('GetMessageUseCase a été réussi');
     messageController.close();
    }catch (e){
      logger.severe('GetMessageUsecase n\'a pas fonctionné...');
      messageController.addError(e);
    }
    return messageController.stream;
  }
}

class GetMessageUseCaseResponse {
  List<chatMessage> message;
  GetMessageUseCaseResponse(this.message);
}

class GetMessageParams {
  String uid;
  GetMessageParams(this.uid);
}

