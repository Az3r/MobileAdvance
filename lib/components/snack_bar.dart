import 'package:flutter/material.dart';

class SuccessSnackBar extends SnackBar {
  final String label;

  SuccessSnackBar({Key key, this.label})
      : super(
          key: key,
          backgroundColor: Colors.green,
          content: Row(
            children: [
              Icon(Icons.check, color: Colors.white),
              SizedBox(width: 8),
              Text(label),
            ],
          ),
        );
}

class ErrorSnackBar extends SnackBar {
  final String label;

  ErrorSnackBar({Key key, this.label})
      : super(
          key: key,
          backgroundColor: Colors.red,
          content: Row(
            children: [
              Icon(Icons.warning, color: Colors.yellow),
              SizedBox(width: 8),
              Text(label),
            ],
          ),
        );
}
