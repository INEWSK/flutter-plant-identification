import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter_hotelapp/models/tree_result.dart';
import 'package:tflite/tflite.dart';

import 'app_log_helper.dart';

class TFLiteHelper {
  static StreamController<List<TreeResult>> tfLiteResultsController =
      new StreamController.broadcast();
  static List<TreeResult> _outputs = [];
  static var modelLoaded = false;

  static Future<String> loadModel() async {
    AppLogHelper.log("loadModel", "Loading model..");

    return Tflite.loadModel(
      model: "assets/models/flora_model.tflite",
      labels: "assets/models/flora_labels.txt",
    );
  }

  static classifyImage(CameraImage image) async {
    await Tflite.runModelOnFrame(
            bytesList: image.planes.map((plane) {
              return plane.bytes;
            }).toList(),
            numResults: 5)
        .then((value) {
      if (value.isNotEmpty) {
        AppLogHelper.log("classifyImage", "Results loaded. ${value.length}");

        //Clear previous results
        _outputs.clear();

        value.forEach((element) {
          _outputs.add(TreeResult(
              element['confidence'], element['index'], element['label']));

          AppLogHelper.log("classifyImage",
              "${element['confidence']} , ${element['index']}, ${element['label']}");
        });
      }

      //Sort results according to most confidence
      _outputs.sort((a, b) => a.confidence.compareTo(b.confidence));

      //Send results
      tfLiteResultsController.add(_outputs);
    });
  }

  static void disposeModel() {
    Tflite.close();
    tfLiteResultsController.close();
  }
}
