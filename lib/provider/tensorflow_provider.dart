import 'package:flutter/cupertino.dart';
import 'package:tflite/tflite.dart';

class TensorflowProvider extends ChangeNotifier {
  loadModel() async {
    var model = await Tflite.loadModel(
      model: 'model',
    );
    print('Result after LOADING model: $model');
  }
}
