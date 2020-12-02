import 'package:flutter/material.dart';

class NetworkError extends StatelessWidget {
  const NetworkError();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(false)),
              alignment: Alignment.topRight,
            ),
            Column(
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
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
