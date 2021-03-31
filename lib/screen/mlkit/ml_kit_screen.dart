import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/screen/mlkit/providers/ml_kit_provider.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class MLKitScreen extends StatefulWidget {
  @override
  _MLKitScreenState createState() => _MLKitScreenState();
}

class _MLKitScreenState extends State<MLKitScreen> {
  Widget readyScreen(MLKitProvider provider) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            provider.image != null
                ? Image.file(provider.image)
                : Text('Please select image to analyze.'),
            Column(
              children: provider.labels != null
                  ? provider.labels.map((label) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: kDefaultPadding,
                        ),
                        child: Text("${label["label"]}"),
                      );
                    }).toList()
                  : [],
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'mlkitCameraBtn',
              tooltip: 'Camera',
              onPressed: () => provider.getImageLabels('camera'),
              child: Icon(Icons.camera),
            ),
            SizedBox(
              height: 16.0,
            ),
            FloatingActionButton(
              heroTag: 'mlkitAlbumBtn',
              tooltip: 'Album',
              onPressed: () => provider.getImageLabels('gallery'),
              child: Icon(
                FontAwesome.photo,
                size: 18.0,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget errorScreen() {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text("Error loading model. Please check the logs."),
      ),
    );
  }

  Widget loadingScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: CircularProgressIndicator(),
            ),
            Text(
                "It won't take long./nPlease make sure that you are using wifi."),
          ],
        ),
      ),
    );
  }

  /// shows different screens based on the state of the custom model.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => MLKitProvider(),
      child: Consumer(builder: (_, MLKitProvider provider, __) {
        return DefaultTextStyle(
          style: Theme.of(context).textTheme.headline2,
          textAlign: TextAlign.center,
          child: screenBuild(provider),
        );
      }),
    );
  }

  Widget screenBuild(provider) {
    return FutureBuilder(
      future:
          provider.loadModel(), // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return readyScreen(provider);
        } else if (snapshot.hasError) {
          return errorScreen();
        } else {
          return loadingScreen();
        }
      },
    );
  }
}
