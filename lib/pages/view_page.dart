import 'package:flutter/material.dart';

class ViewPage extends StatelessWidget {
  final String content;
  ViewPage(this.content);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('View'),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(15),
            child: Text(content),
          ),
        ));
  }
}
