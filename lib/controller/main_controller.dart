import 'package:get/get.dart';

class MainController extends GetxController {

  final RxInt currentIndex = 0.obs;
  final RxBool isScanning = false.obs;
  final RxBool isConnected = false.obs;
  final RxString brainWaveData = "".obs;

  int currentLogTime = DateTime.now().millisecondsSinceEpoch;

  void  changePage(int index)  {
    currentIndex.value = index;
  }



}

String formatTime(int timeStamp) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeStamp);
  String formattedTime =
      "${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}";
  return formattedTime;
}
