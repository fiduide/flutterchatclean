import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutterchatapp/domain/usecases/get_message_usercase.dart';

class ChatPresenter extends Presenter {
  Function getMessageOnNext;
  Function getMessageOnComplete;
  Function getMessageOnError;
  Function getMessageOnWaiting;

  final GetMessageUseCase getMessageUseCase;
  ChatPresenter(messageRepo) : getMessageUseCase = GetMessageUseCase(messageRepo);

  void getMessage() {
    getMessageUseCase.execute(_GetMessageObserver(this));
  }

  @override
  void dispose(){
    getMessageUseCase.dispose();
  }
}

class _GetMessageObserver extends Observer<GetMessageUseCaseResponse> {
  final ChatPresenter presenter;
  _GetMessageObserver(this.presenter);

  @override
  void onComplete(){
    assert(presenter.getMessageUseCase != null);
    presenter.getMessageOnComplete();
  }

  @override
  void onError(e){
    assert(presenter.getMessageOnComplete != null);
    presenter.getMessageOnError();
  }

  @override
  void onNext(response){
    assert(presenter.getMessageOnNext != null);
    presenter.getMessageOnNext(response.message);
  }

  @override
  void onWaiting(){
    assert(presenter.getMessageOnComplete == null);
    presenter.getMessageOnWaiting();
  }
}