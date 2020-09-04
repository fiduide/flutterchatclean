import 'package:flutterchatapp/domain/repositories/PictureInterface.dart';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';




class DataPictureRepository extends PictureRepository {

  Future<Uint8List> getPicture() async {
    int index = 1;
    int maxSize = 7*1024*1024;
    Uint8List imageFile;

    StorageReference photoReference =  FirebaseStorage.instance.ref().child("");

    await photoReference.child("$index.jpg").getData(maxSize).then((picture) {
        imageFile = picture;
        print(imageFile);
      });
    return imageFile;
  }
}