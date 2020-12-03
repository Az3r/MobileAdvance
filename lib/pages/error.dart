import 'package:flutter/material.dart';

class NetworkError extends StatelessWidget {
  const NetworkError();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.white,
        child: Icon(Icons.close),
        onPressed: () => Navigator.of(context).pop(false),
      ),
      body: Center(
        child: Container(
          width: 480,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('assets/images/error.png'),
              SizedBox(height: 16),
              Text(
                'No internet connection, please try again',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              SizedBox(height: 8),
              ElevatedButton(
                child: Text('TRY AGAIN'),
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(primary: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
