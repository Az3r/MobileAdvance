import 'package:flutter/material.dart';

class NetworkError extends StatelessWidget {
  final String message;
  final bool allowRetry;
  const NetworkError.disconnected({
    Key key,
    this.message = 'No internet connection, please try again',
    this.allowRetry = true,
  }) : super(key: key);

  const NetworkError.exceedQuota({
    Key key,
    this.message = 'You have exceeded today quota!',
    this.allowRetry = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          width: 480,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('assets/images/error.png'),
              SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              SizedBox(height: 8),
              if (allowRetry)
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
