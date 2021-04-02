import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ml_custom/firebase_ml_custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hotelapp/common/utils/log_error.dart';
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
    final modelFile = await _loadModelFromFirebase();
    final modelLabel = await _loadLabelFromNetwork();
    final model = await _loadTFLiteModel(modelFile, modelLabel);
    return model;
  }

  /// downloads custom model from the Firebase console and return its file.
  /// located on the mobile device.
  static Future<File> _loadModelFromFirebase() async {
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

  static Future<File> _loadLabelFromNetwork() async {
    final appDirectory = await getApplicationDocumentsDirectory();

    try {
      final url = 'http://10.0.2.2:8000/flora/tree-ai-labels/';

      Dio dio = Dio();

      ///參數一 文件URL
      ///參數二 下載的本地目錄文件
      ///參數三 下載監聽
      await dio.download(url, appDirectory.path + "/_network_flora_labels.txt",
          onReceiveProgress: (rec, total) {
        print("Rec: $rec , Total: $total");
      });

      final labelsFile = File(appDirectory.path + "/_network_flora_labels.txt");

      //記得關閉 dio
      dio.close();

      return labelsFile;
    } catch (e) {
      print('Failed on loading  model label from network: $e');
      LogError.show('MLKIT', '從 api 下載 txt 文件失敗, 讀取內置 labels.txt');
      // local assets file
      final labelsData =
          await rootBundle.load("assets/models/flora_labels.txt");
      final labelsFile =
          await File(appDirectory.path + "/_local_flora_labels.txt")
              .writeAsBytes(labelsData.buffer.asUint8List(
                  labelsData.offsetInBytes, labelsData.lengthInBytes));

      return labelsFile;
    }
  }

  static void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  /// loads the model into some TF Lite interpreter.
  /// in this case interpreter provided by tflite plugin.
  static Future<String> _loadTFLiteModel(
      File modelFile, File modelLabel) async {
    try {
      assert(await Tflite.loadModel(
            model: modelFile.path,
            labels: modelLabel.path,
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
