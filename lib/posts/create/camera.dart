import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ImageModel.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;


  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController
    _controller = CameraController(
        // Get a specific camera from the list of available cameras.
        widget.camera,
        // Define the resolution to use.
        ResolutionPreset.medium,
      );
      // Next, initialize the controller. This returns a Future.
      _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;
            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final xfile = await _controller.takePicture();
            final image = File(xfile.path);
            var photos = context.read<ImageModel>();
            photos.add(image);
            Navigator.pop(context);
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
        backgroundColor: Colors.purpleAccent,
      ),
    );
  }
}