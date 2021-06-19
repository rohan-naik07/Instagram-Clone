import 'dart:io';
import 'package:flutter/foundation.dart';

class ImageModel extends ChangeNotifier {
  /// Internal, private state
  final List<File> _photos = [];
  List<File> get photos => _photos;
  int get length=>_photos.length;
  File get (index)=>_photos[index];

  /// Adds [item] to cart. This is the only way to modify the cart from outside.
  void add(File file) {
   _photos.add(file);
    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
  }

  void remove(File file) {
    _photos.remove(file);
    // Don't forget to tell dependent widgets to rebuild _every time_
    // you change the model.
    notifyListeners();
  }
}


