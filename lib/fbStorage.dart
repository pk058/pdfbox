import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';


class StorageServices {
  //
  Map<String, String> _paths;
  String _extension;
  FileType _pickType = FileType.image;
  List<StorageUploadTask> _tasks = <StorageUploadTask>[];

  openFileExplorer() async {
    try {
      _paths = await FilePicker.getMultiFilePath(
          type: _pickType);
      uploadToFirebase();
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
  }

  uploadToFirebase() {
    _paths.forEach((fileName, filePath) => {upload(fileName, filePath)});
  }

  upload(fileName, filePath) {
    _extension = fileName.toString().split('.').last;
    StorageReference storageRef =
    FirebaseStorage.instance.ref().child(fileName);
    final StorageUploadTask uploadTask = storageRef.putFile(
      File(filePath),
      StorageMetadata(
        contentType: '$_pickType/$_extension',
      ),
    );
      _tasks.add(uploadTask);
  }

//  dropDown() {
//    return DropdownButton(
//      hint: new Text('Select'),
//      value: _pickType,
//      items: <DropdownMenuItem>[
//        new DropdownMenuItem(
//          child: new Text('Audio'),
//          value: FileType.audio,
//        ),
//        new DropdownMenuItem(
//          child: new Text('Image'),
//          value: FileType.image,
//        ),
//        new DropdownMenuItem(
//          child: new Text('Video'),
//          value: FileType.video,
//        ),
//        new DropdownMenuItem(
//          child: new Text('Any'),
//          value: FileType.any,
//        ),
//      ],
//      onChanged: (value) => setState(() {
//        _pickType = value;
//      }),
//

  String filename(){
    String name;
    _paths.forEach((fileName, filePath) {
      name = fileName.toString().split('.').first;
    });
    return name;
  }

  tileBuilder(){
  final List<Widget> children = <Widget>[];
  _tasks.forEach((StorageUploadTask task) {
  final Widget tile = UploadTaskListTile(
  task: task,
  onDismissed: () => _tasks.remove(task),
  onDownload: () => downloadFile(task.lastSnapshot.ref),
  name: filename(),
  );
  children.add(tile);
  });
  return ListView(
  children: children,
  );
}


  }



  Future<void> downloadFile(StorageReference ref) async {
    final String url = await ref.getDownloadURL();

    final Directory systemTempDir = Directory.systemTemp;
    final File tempFile = File('${systemTempDir.path}/tmp.jpg');
    if (tempFile.existsSync()) {
      await tempFile.delete();
    }
    await tempFile.create();
    final StorageFileDownloadTask task = ref.writeToFile(tempFile);
    final int byteCount = (await task.future).totalByteCount;
    final String name = await ref.getName();
    final String path = await ref.getPath();
    print(
      'Success!\nDownloaded $name \nUrl: $url'
          '\npath: $path \nBytes Count :: $byteCount',
    );
  }


class UploadTaskListTile extends StatelessWidget {
  const UploadTaskListTile(
      {Key key, this.task, this.onDismissed, this.onDownload, this.name,})
      : super(key: key);

  final StorageUploadTask task;
  final VoidCallback onDismissed;
  final VoidCallback onDownload;
  final String name;

  String get status {
    String result;
    if (task.isComplete) {
      if (task.isSuccessful) {
        result = 'Complete';
      } else if (task.isCanceled) {
        result = 'Canceled';
      } else {
        result = 'Failed ERROR: ${task.lastSnapshot.error}';
      }
    } else if (task.isInProgress) {
      result = 'Uploading';
    } else if (task.isPaused) {
      result = 'Paused';
    }
    return result;
  }

  String _bytesTransferred(StorageTaskSnapshot snapshot) {
    return '${snapshot.bytesTransferred}/${snapshot.totalByteCount}';
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StorageTaskEvent>(
      stream: task.events,
      builder: (BuildContext context,
          AsyncSnapshot<StorageTaskEvent> asyncSnapshot) {
        Widget subtitle;
        if (asyncSnapshot.hasData) {
          final StorageTaskEvent event = asyncSnapshot.data;
          final StorageTaskSnapshot snapshot = event.snapshot;
          subtitle = Text('$status: ${_bytesTransferred(snapshot)} bytes sent');
        } else {
          subtitle = const Text('Starting...');
        }
        return Dismissible(
          key: Key(task.hashCode.toString()),
          onDismissed: (_) => onDismissed(),
          child: ListTile(
//            title: Text('Upload Task #${task.hashCode}'),
            title: Text(name),
            subtitle: subtitle,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Offstage(
                  offstage: !task.isInProgress,
                  child: IconButton(
                    icon: const Icon(Icons.pause),
                    onPressed: () => task.pause(),
                  ),
                ),
                Offstage(
                  offstage: !task.isPaused,
                  child: IconButton(
                    icon: const Icon(Icons.file_upload),
                    onPressed: () => task.resume(),
                  ),
                ),
                Offstage(
                  offstage: task.isComplete,
                  child: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () => task.cancel(),
                  ),
                ),
                Offstage(
                  offstage: !(task.isComplete && task.isSuccessful),
                  child: IconButton(
                    icon: const Icon(Icons.file_download),
                    onPressed: onDownload,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}