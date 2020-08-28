library app2;

import 'package:flutter/material.dart';

class SecondPageArguments {
  final String title;
  final String message;

  SecondPageArguments(this.title, this.message);
}

class SecondPageWidget extends StatelessWidget {
  static const routeName = '/second';

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments ?? {};
    final String title =
        args.containsKey('title') ? args['title'] : "Second Page";
    final String message = args.containsKey('message')
        ? args['message']
        : "Message from Second Page";

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          children: [
            Text("Hello, $message!"),
            RaisedButton(
              child: Text("Back"),
              onPressed: () {
                Navigator.pop(context, 'Return from Second Page');
              },
            )
          ],
        ),
      ),
    );
  }
}
