import 'package:first_flutter_project/posts/create/camera.dart';
import 'package:first_flutter_project/posts/create/photos.dart';
import 'package:first_flutter_project/posts/create/submit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'ImageModel.dart';

class CreatePostPage extends StatelessWidget {

  Future<CameraDescription> initCamera() async {
    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();
    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;
    return firstCamera;
  }

  @override
  Widget build(BuildContext context) {
    // Using MultiProvider is convenient when providing multiple objects.
    return FutureBuilder<CameraDescription>(
        future: initCamera(),
        builder: (BuildContext context,AsyncSnapshot<CameraDescription> snapshot){
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<ImageModel>(
                  create: (context) => ImageModel()
              ),
            ],
            child: MaterialApp(
              initialRoute: '/',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primaryColor: Colors.black,
              ),
              routes: {
                '/': (context) => PhotosPage(),
                '/takepic': (context) => TakePictureScreen(camera:snapshot.data!),
                '/submit': (context) => SubmitPage(),
              },
            ),
          );
        }
    );
  }
}