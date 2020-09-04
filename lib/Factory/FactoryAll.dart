import '../data/repositories/DataFirebaseRepository.dart';
import '../data/repositories/DataSQLRepository.dart';
import 'package:flutterchatapp/domain/repositories/ChatBePitchInterface.dart';

class FactoryAll{

ChatBePitchInterface messageSource;

  FactoryAll(int sourcetype){
    if(sourcetype == 1) {
      this.messageSource =  new AdapteurFirebase();
    }else if(sourcetype == 0){
      this.messageSource =  new AdapteurMysql();
    }
  }

}


