import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final message;
  const ErrorMessage({Key key, this.message}) : super(key: key);
  const ErrorMessage.disconnected({Key key})
      : message = 'No internet connection, please try again',
        super(key: key);
  const ErrorMessage.quotaExceeded({Key key})
      : message = 'You have exceeded today quota!',
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
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
          ],
        ),
      ),
    );
  }
}

class NetworkImageError extends StatelessWidget {
  final dynamic error;
  const NetworkImageError({Key key, this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Image Error',
            style: Theme.of(context).textTheme.headline6,
          ),
          content: Text(error.toString()),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.warning,
            color: Colors.yellow,
          ),
          Text('Failed to load image',
              style: Theme.of(context).textTheme.bodyText1),
        ],
      ),
    );
  }
}
