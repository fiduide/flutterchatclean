import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutterchatapp/domain/usecases/get_picture_usecase.dart';


class PicturePresenter extends Presenter {
  Function getPictureOnNext;
  Function getPictureOnComplete;
  Function getPictureOnError;

  final GetPictureUseCase getPictureUseCase;

  PicturePresenter(imageRepo)
      : getPictureUseCase = GetPictureUseCase(imageRepo);

  void getPicture() {
    getPictureUseCase.execute(_GetPictureUseCaseObserver(this));
  }

  @override
  void dispose() {
    getPictureUseCase.dispose();
  }
}

class _GetPictureUseCaseObserver extends Observer<GetPictureUseCaseResponse> {

    final PicturePresenter presenter;
    _GetPictureUseCaseObserver(this.presenter);

    @override
    void onComplete() {
      assert(presenter.getPictureOnNext != null);
      presenter.getPictureOnComplete();
    }

    @override
    void onError(e) {
      assert(presenter.getPictureOnError != null);
      presenter.getPictureOnError(e);
    }

    @override
    void onNext(response) {
      assert(presenter.getPictureOnNext != null);
      presenter.getPictureOnNext(response.picture);
    }
}