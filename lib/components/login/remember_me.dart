import 'package:flutter/material.dart';

class RememberMe extends StatefulWidget {
  const RememberMe({Key key}) : super(key: key);
  @override
  RememberMeState createState() => RememberMeState();
}

class RememberMeState extends State<RememberMe> {
  var checked = false;
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.only(left: 4),
      controlAffinity: ListTileControlAffinity.leading,
      value: checked,
      onChanged: (value) => setState(() => checked = value),
      title: Text('Remember me', style: Theme.of(context).textTheme.subtitle2),
    );
  }
}
