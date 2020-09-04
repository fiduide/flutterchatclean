import 'dart:typed_data';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter/material.dart';
import 'package:flutterchatapp/app/pages/pictureList/picture_presenter.dart';


class PictureController extends Controller {
  Uint8List _images;
  Uint8List  get images => _images;

  final PicturePresenter picturePresenter;

  PictureController(imageRepo) : picturePresenter = PicturePresenter(imageRepo), super();

  @override
  void initListeners() {
    picturePresenter.getPictureOnNext = (Uint8List images) {
        _images = images;
        refreshUI();
    };
    picturePresenter.getPictureOnComplete = () {
      print('Images récupérées');
    };
    picturePresenter.getPictureOnError = (e) {
      print('Impossible de récupérer les images');
      ScaffoldState state = getState();
      state.showSnackBar(SnackBar(content: Text('Impossible de récupérer les images')));
      refreshUI();
    };
  }

  void getPicture() => picturePresenter.getPicture();

  @override
  void onResumed() {
    print("en pause");
    super.onResumed();
  }

  @override
  void dispose() {
    picturePresenter.dispose();
    super.dispose();
  }
}