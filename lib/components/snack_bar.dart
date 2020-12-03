import 'package:flutter/material.dart';

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
