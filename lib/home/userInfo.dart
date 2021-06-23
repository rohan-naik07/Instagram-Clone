import 'package:flutter/foundation.dart';

class UserModel extends ChangeNotifier {
  /// Internal, private state
  var  _user ;
  get info => _user;
  
  /// Adds [item] to cart. This is the only way to modify the cart from outside.
  void add(user) {
    _user = user;
    notifyListeners();
  }

  void remove() {
    _user = {};
     notifyListeners();
  }
}


