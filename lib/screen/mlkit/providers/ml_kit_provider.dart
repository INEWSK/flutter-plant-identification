import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ml_custom/firebase_ml_custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hotelapp/common/utils/toast_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite/tflite.dart';

class MLKitProvider extends ChangeNotifier {
  File _image;
  List<Map<dynamic, dynamic>> _labels;

  File get image => _image;
  List<Map<dynamic, dynamic>> get labels => _labels;

  /// Gets the model ready for inference on images.
  Future<String> loadModel() async {
    final modelFile = await loadModelFromFirebase();
    final model = await loadTFLiteModel(modelFile);
    return model;
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
    } on FirebaseException catch (exception) {
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
  Future<void> getImageLabels(String pickSource) async {
    try {
      final pickedFile = await ImagePicker().getImage(
          source: pickSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery);
      final image = File(pickedFile.path);
      if (image == null) {
        return;
      }
      var labels = List<Map>.from(await Tflite.runModelOnImage(
        path: image.path,
        imageStd: 127.5,
      ));

      _labels = labels;
      _image = image;
      notifyListeners();
    } catch (exception) {
      print("Failed on getting your image and it's labels: $exception");
      print('Continuing with the program...');
      rethrow;
    }
  }
}
