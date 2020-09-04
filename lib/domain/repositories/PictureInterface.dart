import 'dart:typed_data';


abstract class PictureRepository {

  Future<Uint8List> getPicture();

}