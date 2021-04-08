import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class AgreementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _text(),
    );
  }

  _text() {
    return FutureBuilder(
      future: rootBundle.loadString("assets/md/license_agreement.md"),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Markdown(data: snapshot.data);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
