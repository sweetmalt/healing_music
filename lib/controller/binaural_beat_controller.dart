import 'package:get/get.dart';

class BinauralBeatController extends GetxController {
  var deltaWave = false.obs;
  var alphaWave = false.obs;
  var gammaWave = false.obs;
  void setDeltaWave(bool value) {
    deltaWave.value = value;
    if (value) {
      alphaWave.value = false;
      gammaWave.value = false;
    }
  }
  void setAlphaWave(bool value) {
    alphaWave.value = value;
    if (value) {
      deltaWave.value = false;
      gammaWave.value = false;
    }
  }
  void setGammaWave(bool value) {
    gammaWave.value = value;
    if (value) {
      deltaWave.value = false;
      alphaWave.value = false;
    }
  }
}
