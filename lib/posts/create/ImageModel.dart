import 'package:flutter/foundation.dart';

class ImageModel extends ChangeNotifier {
  /// Internal, private state
  final List<String> _photos = [];
  List<String> get photos => _photos;
  int get length=>_photos.length;
  String get (index)=>_photos[index];

  /// Adds [item] to cart. This is the only way to modify the cart from outside.
  void add(String string) {
   _photos.add(string);
    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
  }

  void remove(String string) {
    _photos.remove(string);
    // Don't forget to tell dependent widgets to rebuild _every time_
    // you change the model.
    notifyListeners();
  }

  void removeAll() {
    _photos.clear();
    // Don't forget to tell dependent widgets to rebuild _every time_
    // you change the model.
    notifyListeners();
  }

}


