import 'dart:io';

import 'package:firebase_ml_custom/firebase_ml_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite/tflite.dart';

class MLKitScreen extends StatefulWidget {
  @override
  _MLKitScreenState createState() => _MLKitScreenState();
}

class _MLKitScreenState extends State<MLKitScreen> {
  File _image;
  List<Map<dynamic, dynamic>> _labels;

  /// Gets the model ready for inference on images.
  static Future<String> _loadModel() async {
    final modelFile = await loadModelFromFirebase();
    return await loadTFLiteModel(modelFile);
  }

  /// downloads custom model from the Firebase console and return its file.
  /// located on the mobile device.
  static Future<File> loadModelFromFirebase() async {
    try {
      // create model with a name that is specified in the Firebase console
      final model = FirebaseCustomRemoteModel('flora_leaf_model');

      // specify conditions when the model can be downloaded.
      // If there is no wifi access when the app is started,
      // this app will continue loading until the conditions are satisfied.
      final conditions = FirebaseModelDownloadConditions(
          androidRequireWifi: false, iosAllowCellularAccess: false);

      // create model manager associated with default Firebase App instance.
      final modelManager = FirebaseModelManager.instance;

      // begin downloading and wait until the model is downloaded successfully.
      await modelManager.download(model, conditions);
      assert(await modelManager.isModelDownloaded(model) == true);

      // get latest model file to use it for inference by the interpreter.
      var modelFile = await modelManager.getLatestModelFile(model);
      assert(modelFile != null);
      return modelFile;
    } catch (exception) {
      print('Failed on loading your model from Firebase: $exception');
      print('The program will not be resumed');
      rethrow;
    }
  }

  /// loads the model into some TF Lite interpreter.
  /// in this case interpreter provided by tflite plugin.
  static Future<String> loadTFLiteModel(File modelFile) async {
    try {
      final appDirectory = await getApplicationDocumentsDirectory();
      final labelsData =
          await rootBundle.load("assets/models/flora_labels.txt");
      final labelsFile = await File(appDirectory.path + "/_flora_labels.txt")
          .writeAsBytes(labelsData.buffer
              .asUint8List(labelsData.offsetInBytes, labelsData.lengthInBytes));

      assert(await Tflite.loadModel(
            model: modelFile.path,
            labels: labelsFile.path,
            isAsset: false,
          ) ==
          "success");
      return "Model is loaded";
    } catch (exception) {
      print(
          'Failed on loading your model to the TFLite interpreter: $exception');
      print('The program will not be resumed');
      rethrow;
    }
  }

  /// triggers selection of an image and the consequent inference.
  Future<void> getImageLabels() async {
    try {
      final pickedFile =
          await ImagePicker().getImage(source: ImageSource.gallery);
      final image = File(pickedFile.path);
      if (image == null) {
        return;
      }
      var labels = List<Map>.from(await Tflite.runModelOnImage(
        path: image.path,
        imageStd: 127.5,
      ));
      setState(() {
        _labels = labels;
        _image = image;
      });
    } catch (exception) {
      print("Failed on getting your image and it's labels: $exception");
      print('Continuing with the program...');
      rethrow;
    }
  }

  Widget readyScreen() {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          _image != null
              ? Image.file(_image)
              : Center(child: Text('Please select image to analyze.')),
          Column(
            children: _labels != null
                ? _labels.map((label) {
                    return Text("${label["label"]}");
                  }).toList()
                : [],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImageLabels,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget errorScreen() {
    return Scaffold(
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
                "It won't take long. Please make sure that you are using wifi."),
          ],
        ),
      ),
    );
  }

  /// shows different screens based on the state of the custom model.
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline2,
      textAlign: TextAlign.center,
      child: FutureBuilder<String>(
        future: _loadModel(), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return readyScreen();
          } else if (snapshot.hasError) {
            return errorScreen();
          } else {
            return loadingScreen();
          }
        },
      ),
    );
  }
}
