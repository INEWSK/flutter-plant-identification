import 'package:flutter/material.dart';

import 'components/detail_widget.dart';

class DetailTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: DetailPageWidget(
        commonName: 'This is common name',
        scientificName: 'This is scientific name',
        chineseName: '這是中文名',
      ),
    );
  }
}
