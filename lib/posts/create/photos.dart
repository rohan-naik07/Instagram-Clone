import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'ImageModel.dart';

class PhotosPage extends StatefulWidget {
  @override
  _PhotosState createState() => _PhotosState();
}

class _PhotosState extends State<PhotosPage> {
  late String _error;
  Widget? buildGridView(images) {
    if (images != null && images.length!=0)
      return Expanded(
        child: SizedBox(
          height: 200,
          child: GridView.count(
            crossAxisCount: 2,
            children: List.generate(images.length, (index) {
              File file = images.get(index);
              return Padding(
                padding: EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular (15)),
                  child: Image.file(file,width: 100,height: 100) // AssetThumb
                ),
              );
            }),
          )
        ),
      );
    else
      return Container(
        height: 500,
        width: double.infinity,
        child: Column(
          // Vertically center the widget inside the column
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text( 'No images selected', style: TextStyle(color: Colors.grey, fontSize: 10))
          ],
        ),
      );
  }

  loadAssets() async {
    String error = 'No Error Dectected';
    try {
      List<Asset> assetList =  await MultiImagePicker.pickImages(
        maxImages: 4,
        enableCamera: true,
        //selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat")
      );
      assetList.forEach((element) async {
        final filePath = await FlutterAbsolutePath.getAbsolutePath(element.identifier);
        File file = await getImageFileFromAsset(filePath);
        var photos = context.read<ImageModel>();
        photos.add(file);
      });
    } on Exception catch (e) {
      error = e.toString();
      setState((){
        _error = error;
      });
    }
    if (!mounted) return;
  }

  Future<File> getImageFileFromAsset(String path) async {
    final file = File(path);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    var photos = context.watch<ImageModel>();

    // TODO: implement build
          return Container(
              child: Column (
                children: <Widget> [
                  Padding (
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                            onPressed: ()=>Navigator.pushNamed(context, '/takepic'),
                            icon: Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.white,
                            )
                        ),
                        TextButton(
                          onPressed: () async { await loadAssets(); },
                          child:Container(
                            height: 20,
                            width: 60,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child : Text( 'Select From Gallery', style: TextStyle(color: Colors.white, fontSize: 10))
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: ()=>Navigator.pushNamed(context, '/submit'),
                          child:Container(
                            height: 20,
                            width: 60,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child : Text( 'Next', style: TextStyle(color: Colors.white, fontSize: 10))
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  buildGridView(photos)!
                ],
              )
          );
    }
}