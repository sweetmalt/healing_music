import 'package:get/get.dart';
import 'package:healing_music/data/json.dart';

class MainController extends GetxController {
  final Agency agency = Agency();
  final User user = User();

  final RxInt currentIndex = 0.obs;
  final RxBool isScanning = false.obs;
  final RxBool isConnected = false.obs;
  final RxString brainWaveData = "".obs;

  int currentLogTime = DateTime.now().millisecondsSinceEpoch;

  void changePage(int index) {
    currentIndex.value = index;
  }

  final RxString userName = "".obs;
  final RxString userCode = "".obs;
  final RxString userNickname = "".obs;
  final RxString userPhoneNumber = "".obs;
  final RxString userAddress = "".obs;
  final RxString regTime = "".obs;
  final RxString logTime = "".obs;

  void synUserInfo() {
    userName.value = user.getName();
    userCode.value = user.getCode();
    userNickname.value = user.getNickname();
    userPhoneNumber.value = user.getPhoneNumber();
    userAddress.value = user.getAddress();
    if (agency.getRegTime() > 0) {
      regTime.value = formatTime(agency.getRegTime());
    }
    if (agency.getLogTime() > 0) {
      logTime.value = formatTime(agency.getLogTime());
    }
  }
}

String formatTime(int timeStamp) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeStamp);
  String formattedTime =
      "${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}";
  return formattedTime;
}
