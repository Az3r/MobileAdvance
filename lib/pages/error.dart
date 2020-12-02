import 'package:flutter/material.dart';

class NetworkError extends StatelessWidget {
  final VoidCallback callback;

  const NetworkError({Key key, this.callback}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/error.png'),
          SizedBox(height: 16),
          Text(
            'No internet connection, please try again',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(height: 8),
          ElevatedButton(
            child: Text('TRY AGAIN'),
            onPressed: callback,
            style: ElevatedButton.styleFrom(primary: Colors.red),
          ),
        ],
      ),
    );
  }
}
