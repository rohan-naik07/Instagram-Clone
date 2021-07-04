import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Error {
  static Future<void> showError(BuildContext context,String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.red
            ),
            child: ListBody(
              children: <Widget>[
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                  )
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () { Navigator.of(context).pop(); },
              child: const Text('OK', 
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15
                )
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget errorContainer(String message){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[800]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.error,
            size: 30,
            color: Colors.red
          ),
          Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15
            )
          ),
        ],
      )
    );
  }
}