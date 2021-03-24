import 'package:flutter/material.dart';

class LaborScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _body(context),
    );
  }

  _body(BuildContext context) {
    return ListTile(
      title: Text('Tensorflow Lite'),
      onTap: () {
        Navigator.pushReplacementNamed(context, '/tensorflow');
      },
    );
  }
}
