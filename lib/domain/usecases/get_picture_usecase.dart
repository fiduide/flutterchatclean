import 'dart:typed_data';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutterchatapp/domain/repositories/PictureInterface.dart';
import 'dart:async';

class GetPictureUseCase extends UseCase<GetPictureUseCaseResponse, GetPictureUseCasePrams> {

  PictureRepository pictureRepository;
  GetPictureUseCase(this.pictureRepository);

  @override
  Future<Stream<GetPictureUseCaseResponse>> buildUseCaseStream(GetPictureUseCasePrams params) async{

    StreamController pictureController = StreamController<GetPictureUseCaseResponse> ();

    try{
      Uint8List picture = await pictureRepository.getPicture();
      pictureController.add(GetPictureUseCaseResponse((picture)));
      print(picture);
      logger.finest('GetPictureUseCase successful.');
      pictureController.close();
    }catch (e){
     logger.severe('GetPictureUseCase unsuccessful.');
     pictureController.addError(e);
    }
    return pictureController.stream;
  }
}

class GetPictureUseCaseResponse {
  Uint8List picture;
  GetPictureUseCaseResponse(this.picture);
}

class GetPictureUseCasePrams {
  String uid;
  GetPictureUseCasePrams(this.uid);
}

