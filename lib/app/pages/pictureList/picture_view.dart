import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutterchatapp/app/pages/pictureList/picture_controller.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutterchatapp/data/repositories/DataPictureRepository.dart';
import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

//Ne fonctionne pas avec la clean Architecture

class ListPic extends StatefulWidget {
  ListPic({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ListPicState createState() => _ListPicState();
}

class _ListPicState extends State<ListPic> {



  static int index = 0;
  int _index = index;
  Map<String, String> _paths;
  String _extension;
  FileType  _imageType = FileType.image;
  static List<StorageUploadTask> _task = <StorageUploadTask>[];

  Timer timer;

  @override
  void initState(){
    super.initState();
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Uploaded List of Picture'),
        ),
        body: Scaffold(
          body: makeImageGrid(),

          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.grey[600],
            splashColor: Colors.blueGrey[300],
            elevation: 8,
            child: Icon(Icons.add_a_photo, color: Colors.white,),
            onPressed: (){
              loadAssets();
            },
          ),

          bottomNavigationBar: BottomAppBar(
            color: Colors.grey[900],
              child: Container(
                height: 50.0,

              )
          ),


          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        )
    );
  }

  Widget makeImageGrid(){
    return GridView.builder(
        itemCount: 2,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index){
          return ImageGrid(index+1);
        });
  }

  //In File
  void loadAssets() async {
    try{
      _paths = await FilePicker.getMultiFilePath(type: _imageType);
      uploadToFirebase();
    }on PlatformException catch (e){
      print('Operation non supportée' + e.toString());
    }
  }

  //Upload in FireBase
  void uploadToFirebase(){
    _paths.forEach((fileName, filePath) => {
      _index++,
      upload("$_index.jpg", filePath),
    });
  }

  void upload(fileName, filePath){
    _extension = fileName.toString().split('.').last;
    StorageReference storageReference = FirebaseStorage.instance.ref().child(fileName);
    final StorageUploadTask uploadTask = storageReference.putFile(
        File(filePath),
        StorageMetadata(
          contentType: '$_imageType/$_extension',
        ));
    setState(() {
      _task.add(uploadTask);
      makeImageGrid();
    });
    taskList(context);
  }

  Future<bool> taskList(BuildContext context) async {
    final List<Widget> children = <Widget>[];
    _task.forEach((StorageUploadTask task) {
      final Widget tile = UploadTaskList(
          task: task,
          onDismissed: () => setState(() => _task.remove(task))
      );
      children.add(tile);
    });

    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Upload Task', style: TextStyle(decoration: TextDecoration.underline),),
            content:  Container(
              width: 0.5,
              height: 100,
              child: Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Flexible(
                      child: ListView(
                        children: children,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(onPressed: (){
                Navigator.of(context).pop();
                setState(() {
                  makeImageGrid();
                });
              },
                  child: Text('OK'))
            ],
          );
        }
    );
  }

}

//class task list
class UploadTaskList extends StatelessWidget{
  const UploadTaskList({Key key, this.task, this.onDismissed, this.onDownload}) : super(key: key);
  final StorageUploadTask task;
  final VoidCallback onDismissed;
  final VoidCallback onDownload;


//Display status

  String get status {
    String result;
    if(task.isComplete){
      if(task.isSuccessful){
        result = 'Fini';
      }else{
        result = 'Erreur dans le téléchargement ${task.lastSnapshot.error}';
      }    }else if(task.isInProgress){
      result = 'En cours...';
    }
    return result;
  }



//display task
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StorageTaskEvent>(
      stream: task.events,
      builder: (BuildContext context, AsyncSnapshot<StorageTaskEvent> asyncSnapshot){
        Widget subtitle;
        if(asyncSnapshot.hasData){
          final StorageTaskEvent event = asyncSnapshot.data;
          final StorageTaskSnapshot snapshot = event.snapshot;
          subtitle = Text('$status');
        }else{
          subtitle = const Text('Lancement...');
        }
        return Dismissible(
          key: Key(task.hashCode.toString()),
          onDismissed: (_) => onDismissed(),
          child: ListTile(
            title: Text("Tâche d'envoie #${task.hashCode}"),
            subtitle: subtitle,
          ),
        );
      },
    );
  }

}

class ImageGrid extends View{
  int _index;

  ImageGrid(int index){
    this._index = index;
  }

  @override
  _ImageGridState createState() => _ImageGridState();
}

class _ImageGridState extends ViewState<ImageGrid, PictureController> {

  _ImageGridState() : super(PictureController(DataPictureRepository()));

  @override
  void initState(){
    controller.getPicture();
    super.initState();
  }

  Widget decideGridTileWidget(){

    Uint8List imageFile = controller.images;

    if(imageFile ==null){
      return Center(child: Text('@'));
    }else{
      return Image.memory(imageFile, fit: BoxFit.cover);
    }
  }



  @override
  Widget buildPage() {
    return GridTile(child: decideGridTileWidget());
  }
}