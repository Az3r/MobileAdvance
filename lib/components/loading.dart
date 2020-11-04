import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final Future<dynamic> future;
  final Widget loading;
  final Function(dynamic data) onCompleted;
  final Function(dynamic error) onError;

  const Loading({
    Key key,
    @required this.future,
    @required this.loading,
    @required this.onCompleted,
    @required this.onError,
  })  : assert(future != null),
        assert(loading != null),
        assert(onError != null),
        assert(onCompleted != null),
        super(key: key);

  @override
  build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) => _onChanged(context, snapshot),
    );
  }

  Widget _onChanged(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.hasData) return onCompleted(snapshot.data);
    if (snapshot.hasError) return onError(snapshot.error);
    return loading;
  }
}
